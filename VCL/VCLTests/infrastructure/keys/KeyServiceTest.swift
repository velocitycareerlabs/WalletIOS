//
//  KeyServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class KeyServiceTest: XCTestCase {
    
    var subject: VCLKeyServiceImpl!
    
    override func setUp() {
        subject = VCLKeyServiceImpl(secretStore: SecretStoreMock.Instance)
    }
    
    func testGenerateDidJwk() {
        subject.generateDidJwk() { didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                let jwkDict = didJwk.value.removePrefix(VCLDidJwk.DidJwkPrefix).decodeBase64()?.toDictionary()
                
                assert(didJwk.value.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasSuffix(VCLDidJwk.DidJwkSuffix))
                
                assert(jwkDict?["kty"] as? String == "EC")
                assert(jwkDict?["use"] as? String == "sig")
                assert(jwkDict?["crv"] as? String == "secp256k1")
//                assert(jwkDict?["alg"] as? String == "ES256K")
                assert(jwkDict?["use"] as? String == "sig")
                assert(jwkDict?["x"] as? String != nil)
                assert(jwkDict?["y"] as? String != nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
