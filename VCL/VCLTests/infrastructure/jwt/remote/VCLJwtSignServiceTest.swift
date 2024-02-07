//
//  VCLJwtSignServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 01/11/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLJwtSignServiceTest: XCTestCase {
    private var subject: VCLJwtSignServiceRemoteImpl!
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self!.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        
        subject = VCLJwtSignServiceRemoteImpl(
            NetworkServiceSuccess(validResponse: ""),
            ""
        )
    }

    func testGenerateJwtPayloadToSign() {
        let payloadToSign = subject.generateJwtPayloadToSign(
            didJwk: didJwk,
            nonce: "nonce 1",
            jwtDescriptor: VCLJwtDescriptor(
                payload: "{\"payload\": \"payload 1\"}".toDictionary(),
                jti: "jti 1",
                iss: "iss 1",
                aud: "aud 1"
            )
        )
        let header = payloadToSign["header"] as? [String: Any]
        let options = payloadToSign["options"] as? [String: Any]
        let payload = payloadToSign["payload"] as? [String: Any]

        assert(header?["kid"] as? String == didJwk.kid)
        assert(header?["jwk"] as? [String: Any] ?? [:] == didJwk.publicJwk.valueDict)
        
        assert(options?["keyId"] as? String == didJwk.keyId)

        assert(payload?["nonce"] as? String == "nonce 1")
        assert(payload?["aud"] as? String == "aud 1")
        assert(payload?["iss"] as? String == "iss 1")
        assert(payload?["jti"] as? String == "jti 1")
    }
}
