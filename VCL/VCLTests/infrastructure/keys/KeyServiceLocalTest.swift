//
//  KeyServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import CryptoKit
import Foundation
import VCCrypto
import XCTest
@testable import VCL

class KeyServiceLocalTest: XCTestCase {
    
    private var subject: VCLKeyServiceLocalImpl!
    
    override func setUp() {
        subject = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    }
    
    func testGenerateDidJwkSecp256k1() {
        subject.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
        ) { didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                let jwkDict = didJwk.publicJwk.valueDict
                
                assert(didJwk.did.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasSuffix(VCLDidJwk.DidJwkSuffix))
                
                assert(jwkDict["kty"] as? String == "EC")
                assert(jwkDict["use"] as? String == "sig")
                assert(jwkDict["crv"] as? String == VCLSignatureAlgorithm.SECP256k1.curve)
                assert(jwkDict["use"] as? String == "sig")
                assert(jwkDict["x"] as? String != nil)
                assert(jwkDict["y"] as? String != nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGenerateDidJwkP256() throws {
        let didJwk = try generateDidJwk(VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.ES256))

        try assertP256DidJwk(didJwk)
    }

    func testGenerateDidJwkDefaultsToP256() throws {
        let didJwk = try generateDidJwk(VCLDidJwkDescriptor())

        try assertP256DidJwk(didJwk)
    }

    func testGeneratedP256KeyIsPersistedUnderKeyId() throws {
        let secretStore = ItemTypeSecretStore()
        subject = VCLKeyServiceLocalImpl(secretStore: secretStore)
        let didJwk = try generateDidJwk(VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.ES256))

        XCTAssertEqual(secretStore.savedIds, [try XCTUnwrap(UUID(uuidString: didJwk.keyId))])
        let privateKey = try VCLKeyServiceLocalImpl(secretStore: secretStore).retrieveP256PrivateKey(keyId: didJwk.keyId)
        let publicJwk = try VCLKeyServiceLocalImpl.p256PublicJwk(publicKey: privateKey.publicKey, keyId: didJwk.keyId)
        XCTAssertEqual(publicJwk.toDictionary() as NSDictionary, didJwk.publicJwk.valueDict as NSDictionary)
    }

    private func assertP256DidJwk(_ didJwk: VCLDidJwk, file: StaticString = #filePath, line: UInt = #line) throws {
        let jwkDict = didJwk.publicJwk.valueDict

        XCTAssertTrue(didJwk.did.hasPrefix(VCLDidJwk.DidJwkPrefix), file: file, line: line)
        XCTAssertTrue(didJwk.kid.hasPrefix(didJwk.did), file: file, line: line)
        XCTAssertTrue(didJwk.kid.hasSuffix(VCLDidJwk.DidJwkSuffix), file: file, line: line)
        XCTAssertNotNil(UUID(uuidString: didJwk.keyId), file: file, line: line)

        XCTAssertEqual(jwkDict["kty"] as? String, "EC", file: file, line: line)
        XCTAssertEqual(jwkDict["crv"] as? String, VCLSignatureAlgorithm.ES256.curve, file: file, line: line)
        XCTAssertEqual(jwkDict["use"] as? String, "sig", file: file, line: line)
        XCTAssertEqual(jwkDict["kid"] as? String, didJwk.keyId, file: file, line: line)
        let x = try XCTUnwrap((jwkDict["x"] as? String).flatMap { Data(base64URLEncoded: $0) }, file: file, line: line)
        let y = try XCTUnwrap((jwkDict["y"] as? String).flatMap { Data(base64URLEncoded: $0) }, file: file, line: line)
        XCTAssertNoThrow(try P256.Signing.PublicKey(rawRepresentation: x + y), file: file, line: line)

        let didJwkJson = didJwk.did.removePrefix(VCLDidJwk.DidJwkPrefix).decodeBase64URL()
        XCTAssertEqual(didJwkJson?.toDictionary() as NSDictionary?, jwkDict as NSDictionary, file: file, line: line)
    }

    private func generateDidJwk(_ didJwkDescriptor: VCLDidJwkDescriptor) throws -> VCLDidJwk {
        var result: VCLResult<VCLDidJwk> = .failure(VCLError(message: "generateDidJwk did not complete"))
        subject.generateDidJwk(didJwkDescriptor: didJwkDescriptor) { result = $0 }
        return try result.get()
    }
}

/// Keys secrets by id and item type, so a read only succeeds with the item type the secret was saved under.
private final class ItemTypeSecretStore: SecretStoring {
    private var secrets = [String: Data]()
    private(set) var savedIds = [UUID]()

    func getSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws -> Data {
        guard let secret = secrets[key(id, itemTypeCode)] else {
            throw SecretStoringError.itemNotFound
        }
        return secret
    }

    func saveSecret(id: UUID, itemTypeCode: String, accessGroup: String?, value: inout Data) throws {
        savedIds.append(id)
        secrets[key(id, itemTypeCode)] = value
    }

    func deleteSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws {
        secrets.removeValue(forKey: key(id, itemTypeCode))
    }

    private func key(_ id: UUID, _ itemTypeCode: String) -> String {
        "\(itemTypeCode)/\(id.uuidString)"
    }
}
