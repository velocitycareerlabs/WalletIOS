//
//  LocalJwtVerificationTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

/// Presentation requests and credential manifests fetched through the public SDK entry points.
/// The SDK is set up like the Career Wallet: Remote crypto services without a `jwtVerifyServiceUrl`,
/// so request JWTs are checked by the local verifier against the issuer's DID document.
final class LocalJwtVerificationTest: XCTestCase {

    func testGetPresentationRequestAcceptsEs256RequestSignedByP256DidDocumentKey() throws {
        let presentationRequest = try getPresentationRequest(JwtVerificationMocks.Es256PresentationRequestJwt).get()

        XCTAssertEqual(presentationRequest.jwt.encodedJwt, JwtVerificationMocks.Es256PresentationRequestJwt)
        XCTAssertEqual(presentationRequest.jwt.header?["alg"] as? String, "ES256")
        XCTAssertEqual(presentationRequest.iss, JwtVerificationMocks.Did)
    }

    func testGetPresentationRequestAcceptsEs256kRequestSignedBySecp256k1DidDocumentKey() throws {
        let presentationRequest = try getPresentationRequest(JwtVerificationMocks.Es256kPresentationRequestJwt).get()

        XCTAssertEqual(presentationRequest.jwt.encodedJwt, JwtVerificationMocks.Es256kPresentationRequestJwt)
        XCTAssertEqual(presentationRequest.jwt.header?["alg"] as? String, "ES256K")
        XCTAssertEqual(presentationRequest.iss, JwtVerificationMocks.Did)
    }

    func testGetPresentationRequestRejectsEs256RequestWhoseKidIsASecp256k1Key() {
        let error = failure(of: getPresentationRequest(JwtVerificationMocks.Es256PresentationRequestJwtWithSecp256k1Kid))

        XCTAssertEqual(error?.errorCode, VCLErrorCode.VerifierRequestInvalid.rawValue)
        XCTAssertEqual(error?.validationPhase, ErrorTaxonomy.phaseRequestValidation)
    }

    func testGetCredentialManifestAcceptsEs256ManifestSignedByP256DidDocumentKey() throws {
        let credentialManifest = try getCredentialManifest(JwtVerificationMocks.Es256CredentialManifestJwt).get()

        XCTAssertEqual(credentialManifest.jwt.encodedJwt, JwtVerificationMocks.Es256CredentialManifestJwt)
        XCTAssertEqual(credentialManifest.jwt.header?["alg"] as? String, "ES256")
        XCTAssertEqual(credentialManifest.iss, JwtVerificationMocks.Did)
    }

    func testGetCredentialManifestAcceptsEs256kManifestSignedBySecp256k1DidDocumentKey() throws {
        let credentialManifest = try getCredentialManifest(JwtVerificationMocks.Es256kCredentialManifestJwt).get()

        XCTAssertEqual(credentialManifest.jwt.encodedJwt, JwtVerificationMocks.Es256kCredentialManifestJwt)
        XCTAssertEqual(credentialManifest.jwt.header?["alg"] as? String, "ES256K")
        XCTAssertEqual(credentialManifest.iss, JwtVerificationMocks.Did)
    }

    func testGetCredentialManifestRejectsEs256kManifestWhoseKidIsAP256Key() {
        let error = failure(of: getCredentialManifest(JwtVerificationMocks.Es256kCredentialManifestJwtWithP256Kid))

        XCTAssertEqual(error?.errorCode, VCLErrorCode.IssuerRequestInvalid.rawValue)
        XCTAssertEqual(error?.validationPhase, ErrorTaxonomy.phaseRequestValidation)
    }

    private func getPresentationRequest(_ encodedJwt: String) -> VCLResult<VCLPresentationRequest> {
        let vcl = initializedVcl(router: BaselineHttpRouter(
            verifiedProfilePayload: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr,
            requestPayload: [VCLPresentationRequest.CodingKeys.KeyPresentationRequest: encodedJwt].toJsonString() ?? "{}",
            didDocumentPayload: JwtVerificationMocks.DidDocumentStr
        ))
        let expectation = expectation(description: "getPresentationRequest")
        var result: VCLResult<VCLPresentationRequest> = .failure(VCLError(message: "getPresentationRequest did not complete"))
        vcl.getPresentationRequest(
            presentationRequestDescriptor: VCLPresentationRequestDescriptor(
                deepLink: VCLDeepLink(value: JwtVerificationMocks.PresentationRequestDeepLinkStr),
                didJwk: DidJwkMocks.DidJwk
            ),
            successHandler: {
                result = .success($0)
                expectation.fulfill()
            },
            errorHandler: {
                result = .failure($0)
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        return result
    }

    private func getCredentialManifest(_ encodedJwt: String) -> VCLResult<VCLCredentialManifest> {
        let vcl = initializedVcl(router: BaselineHttpRouter(
            verifiedProfilePayload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1,
            requestPayload: [VCLCredentialManifest.CodingKeys.KeyIssuingRequest: encodedJwt].toJsonString() ?? "{}",
            didDocumentPayload: JwtVerificationMocks.DidDocumentStr
        ))
        let expectation = expectation(description: "getCredentialManifest")
        var result: VCLResult<VCLCredentialManifest> = .failure(VCLError(message: "getCredentialManifest did not complete"))
        vcl.getCredentialManifest(
            credentialManifestDescriptor: VCLCredentialManifestDescriptorByDeepLink(
                deepLink: VCLDeepLink(value: JwtVerificationMocks.CredentialManifestDeepLinkStr),
                didJwk: DidJwkMocks.DidJwk
            ),
            successHandler: {
                result = .success($0)
                expectation.fulfill()
            },
            errorHandler: {
                result = .failure($0)
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        return result
    }

    private func initializedVcl(router: BaselineHttpRouter) -> VCLImpl {
        let vcl = VCLImpl(networkServiceFactory: { router })
        let expectation = expectation(description: "VCL initialized")
        var initError: VCLError?
        vcl.initialize(
            initializationDescriptor: VCLInitializationDescriptor(
                cryptoServicesDescriptor: VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: "https://wallet.example.com/create_did_key"),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "https://wallet.example.com/sign")
                    )
                )
            ),
            successHandler: { expectation.fulfill() },
            errorHandler: {
                initError = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(initError, "VCL initialization failed: \(String(describing: initError?.toDictionary()))")
        return vcl
    }

    private func failure<Value>(of result: VCLResult<Value>) -> VCLError? {
        if case .failure(let error) = result {
            return error
        }
        XCTFail("Expected an error, got \(result)")
        return nil
    }
}
