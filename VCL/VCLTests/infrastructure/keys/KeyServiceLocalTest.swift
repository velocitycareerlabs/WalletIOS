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

class KeyServiceLocalTest: XCTestCase {
    
    private var subject: VCLKeyServiceLocalImpl!
    
    override func setUp() {
        subject = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    }
    
    func testGenerateDidJwk() {
        subject.generateDidJwk() { didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                let jwkDict = didJwk.publicJwk.valueDict
                
                assert(didJwk.did.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasPrefix(VCLDidJwk.DidJwkPrefix))
                assert(didJwk.kid.hasSuffix(VCLDidJwk.DidJwkSuffix))
                
                assert(jwkDict["kty"] as? String == "EC")
                assert(jwkDict["use"] as? String == "sig")
                assert(jwkDict["crv"] as? String == "secp256k1")
                assert(jwkDict["use"] as? String == "sig")
                assert(jwkDict["x"] as? String != nil)
                assert(jwkDict["y"] as? String != nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
