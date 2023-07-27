//
//  KeyServiceUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class KeyServiceUseCaseTest: XCTestCase {
    
    var subject: KeyServiceUseCase!

    override func setUp() {
        subject = KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                KeyServiceImpl(secretStore: SecretStoreMock.Instance)
            ),
            EmptyExecutor()
        )
    }

    func testGenerateJwk() {
        var resultDidJwk: VCLResult<VCLDidJwk>? = nil

        subject.generateDidJwk {
            resultDidJwk = $0
        }
        do {
            guard let didJwk = try resultDidJwk?.get() else {
                XCTFail()
                return
            }
            let jwkDict = didJwk.value.removePrefix(VCLDidJwk.DidJwkPrefix).decodeBase64()?.toDictionary()
            
            assert(didJwk.value.hasPrefix(VCLDidJwk.DidJwkPrefix))
            
            assert(jwkDict?["kty"] as? String == "EC")
            assert(jwkDict?["use"] as? String == "sig")
            assert(jwkDict?["crv"] as? String == "secp256k1")
//            assert(jwkDict?["alg"] as? String == "ES256K")
            assert(jwkDict?["use"] as? String == "sig")
            assert(jwkDict?["x"] as? String != nil)
            assert(jwkDict?["y"] as? String != nil)
        } catch {
            XCTFail("\(error)")

        }
    }
    
    func testGenerateDifferentJwks() {
        var resultDidJwk1: VCLResult<VCLDidJwk>? = nil
        var resultDidJwk2: VCLResult<VCLDidJwk>? = nil

        subject.generateDidJwk {
            resultDidJwk1 = $0
        }
        subject.generateDidJwk {
            resultDidJwk2 = $0
        }
        do {
            guard let didJwk1 = try resultDidJwk1?.get() else {
                XCTFail()
                return
            }
            guard let didJwk2 = try resultDidJwk2?.get() else {
                XCTFail()
                return
            }
            assert(didJwk1.value != didJwk2.value)
            assert(didJwk1.keyId != didJwk2.keyId)
        } catch {
            XCTFail("\(error)")

        }
    }
}
