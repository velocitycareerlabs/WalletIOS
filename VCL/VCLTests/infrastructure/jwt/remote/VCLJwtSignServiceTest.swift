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

    override func setUp() {
        subject = VCLJwtSignServiceRemoteImpl(
            NetworkServiceSuccess(validResponse: ""),
            ""
        )
    }

    func testGenerateJwtPayloadToSign() {
        let payloadToSign = subject.generateJwtPayloadToSign(
            kid: "kid 1",
            nonce: "nonce 1",
            jwtDescriptor: VCLJwtDescriptor(
                keyId: "keyId 1",
                payload: "{\"payload\": \"payload 1\"}".toDictionary(),
                jti: "jti 1",
                iss: "iss 1",
                aud: "aud 1"
            )
        )
        let header = payloadToSign["header"] as? [String: String]
        let options = payloadToSign["options"] as? [String: String]
        let payload = payloadToSign["payload"] as? [String: String]

        assert(header?["kid"] == "kid 1")

        assert(options?["keyId"] == "keyId 1")

        assert(payload?["nonce"] == "nonce 1")
        assert(payload?["aud"] == "aud 1")
        assert(payload?["iss"] == "iss 1")
        assert(payload?["jti"] == "jti 1")
    }
}
