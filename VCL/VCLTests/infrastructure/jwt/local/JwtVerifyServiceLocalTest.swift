//
//  JwtVerifyServiceLocalTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/10/2023.
//

import Foundation
import XCTest
@testable import VCL

class JwtVerifyServiceLocalTest: XCTestCase {
    private var subject: VCLJwtVerifyService!
    private var jwtSignService: VCLJwtSignService!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    private let payloadMock = "{\"key1\":\"value1\",\"key2\":\"value2\"}".toDictionary()
    private let jtiMock = "some jti"
    private let issMock = "some iss"
    private let audMock = "some sud"
    private let nonceMock = "some nonce"

    override func setUp() {
        subject = VCLJwtVerifyServiceLocalImpl()
        jwtSignService = VCLJwtSignServiceLocalImpl(keyService)
    }

    func testVerifyEs256PresentationRequestWithP256DidDocumentKey() throws {
        XCTAssertTrue(try verify(JwtVerificationMocks.Es256PresentationRequestJwt, kid: JwtVerificationMocks.P256Kid).get())
    }

    func testVerifyEs256CredentialManifestWithP256DidDocumentKey() throws {
        XCTAssertTrue(try verify(JwtVerificationMocks.Es256CredentialManifestJwt, kid: JwtVerificationMocks.P256Kid).get())
    }

    func testVerifyEs256kPresentationRequestWithSecp256k1DidDocumentKey() throws {
        XCTAssertTrue(try verify(JwtVerificationMocks.Es256kPresentationRequestJwt, kid: JwtVerificationMocks.Secp256k1Kid).get())
    }

    func testVerifyEs256kCredentialManifestWithSecp256k1DidDocumentKey() throws {
        XCTAssertTrue(try verify(JwtVerificationMocks.Es256kCredentialManifestJwt, kid: JwtVerificationMocks.Secp256k1Kid).get())
    }

    func testVerifyEs256AcceptsHighSSignature() throws {
        XCTAssertTrue(try verify(JwtVerificationMocks.Es256PresentationRequestJwtWithHighS, kid: JwtVerificationMocks.P256Kid).get())
    }

    func testVerifyEs256WithAnotherP256KeyDoesNotVerify() throws {
        XCTAssertFalse(try verify(JwtVerificationMocks.Es256PresentationRequestJwt, kid: JwtVerificationMocks.OtherP256Kid).get())
    }

    func testVerifyEs256WithTamperedPayloadDoesNotVerify() throws {
        let presentationRequestParts = JwtVerificationMocks.Es256PresentationRequestJwt.split(separator: ".")
        let credentialManifestParts = JwtVerificationMocks.Es256CredentialManifestJwt.split(separator: ".")
        let tamperedJwt = [presentationRequestParts[0], credentialManifestParts[1], presentationRequestParts[2]].joined(separator: ".")

        XCTAssertFalse(try verify(tamperedJwt, kid: JwtVerificationMocks.P256Kid).get())
    }

    func testVerifyEs256kWithP256KeyFails() {
        assertFailure(verify(JwtVerificationMocks.Es256kPresentationRequestJwt, kid: JwtVerificationMocks.P256Kid))
    }

    func testVerifyEs256WithSecp256k1KeyFails() {
        assertFailure(verify(JwtVerificationMocks.Es256PresentationRequestJwt, kid: JwtVerificationMocks.Secp256k1Kid))
    }

    func testVerifyWithUnsupportedCurveFails() throws {
        var unsupportedJwk = try XCTUnwrap(JwtVerificationMocks.DidDocument.getPublicJwk(kid: JwtVerificationMocks.P256Kid)).valueDict
        unsupportedJwk["crv"] = "P-384"

        assertFailure(verify(
            try VCLJwt(encodedJwt: JwtVerificationMocks.Es256PresentationRequestJwt),
            publicJwk: VCLPublicJwk(valueDict: unsupportedJwk)
        ))
    }

    func testVerifyWithMissingCurveFails() throws {
        var jwkWithoutCurve = try XCTUnwrap(JwtVerificationMocks.DidDocument.getPublicJwk(kid: JwtVerificationMocks.Secp256k1Kid)).valueDict
        jwkWithoutCurve.removeValue(forKey: "crv")

        assertFailure(verify(
            try VCLJwt(encodedJwt: JwtVerificationMocks.Es256kPresentationRequestJwt),
            publicJwk: VCLPublicJwk(valueDict: jwkWithoutCurve)
        ))
    }

    func testVerifyEs256WithNonRawSignatureFails() {
        let parts = JwtVerificationMocks.Es256PresentationRequestJwt.split(separator: ".")
        let truncatedSignatureJwt = "\(parts[0]).\(parts[1]).\(parts[2].dropLast(4))"

        assertFailure(verify(truncatedSignatureJwt, kid: JwtVerificationMocks.P256Kid))
    }

    func testSignAndVerifyEs256WithLocalP256Key() throws {
        let didJwk = try generateDidJwk(.ES256)
        let jwt = try sign(didJwk: didJwk)

        XCTAssertEqual(jwt.header?["alg"] as? String, "ES256")
        XCTAssertEqual(jwt.kid, didJwk.kid)
        XCTAssertTrue(try verify(jwt, publicJwk: didJwk.publicJwk).get())
    }

    func testSignAndVerifyEs256kWithLocalSecp256k1Key() throws {
        let didJwk = try generateDidJwk(.SECP256k1)
        let jwt = try sign(didJwk: didJwk)

        XCTAssertEqual(jwt.header?["alg"] as? String, "ES256K")
        XCTAssertEqual(jwt.kid, didJwk.kid)
        XCTAssertTrue(try verify(jwt, publicJwk: didJwk.publicJwk).get())
    }

    func testLocalSignatureDoesNotVerifyWithAnotherLocalKey() throws {
        let jwt = try sign(didJwk: try generateDidJwk(.ES256))

        XCTAssertFalse(try verify(jwt, publicJwk: try generateDidJwk(.ES256).publicJwk).get())
    }

    private func verify(_ encodedJwt: String, kid: String) -> VCLResult<Bool> {
        guard let publicJwk = JwtVerificationMocks.DidDocument.getPublicJwk(kid: kid) else {
            return .failure(VCLError(message: "No verification method for \(kid)"))
        }
        do {
            return verify(try VCLJwt(encodedJwt: encodedJwt), publicJwk: publicJwk)
        } catch {
            return .failure(VCLError(error: error))
        }
    }

    private func verify(_ jwt: VCLJwt, publicJwk: VCLPublicJwk) -> VCLResult<Bool> {
        var result: VCLResult<Bool> = .failure(VCLError(message: "verify did not complete"))
        subject.verify(jwt: jwt, publicJwk: publicJwk, remoteCryptoServicesToken: nil) { result = $0 }
        return result
    }

    private func assertFailure(_ result: VCLResult<Bool>, file: StaticString = #filePath, line: UInt = #line) {
        if case .success(let verified) = result {
            XCTFail("Expected a verification error, got success(\(verified))", file: file, line: line)
        }
    }

    private func generateDidJwk(_ signatureAlgorithm: VCLSignatureAlgorithm) throws -> VCLDidJwk {
        var result: VCLResult<VCLDidJwk> = .failure(VCLError(message: "generateDidJwk did not complete"))
        keyService.generateDidJwk(didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: signatureAlgorithm)) { result = $0 }
        return try result.get()
    }

    private func sign(didJwk: VCLDidJwk) throws -> VCLJwt {
        var result: VCLResult<VCLJwt> = .failure(VCLError(message: "sign did not complete"))
        jwtSignService.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            ),
            nonce: nonceMock,
            didJwk: didJwk
        ) { result = $0 }
        return try result.get()
    }
}
