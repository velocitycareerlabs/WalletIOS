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
    
    private var subject: KeyServiceUseCase!

    override func setUp() {
        subject = KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
            ),
            EmptyExecutor()
        )
    }

    func testGenerateJwk() {
        subject.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
        ) {
            do {
                let didJwk = try $0.get()
                let jwkDict = didJwk.publicJwk.valueDict

                assert(didJwk.did.hasPrefix(VCLDidJwk.DidJwkPrefix))
                
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
    
    func testGenerateDifferentJwks() {
        subject.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
        ) { [weak self] in
            do {
                let didJwk1 = try $0.get()
                self?.subject.generateDidJwk(
                    didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
                ) {
                    do {
                        let didJwk2 = try $0.get()
                        
                        assert(didJwk1.did != didJwk2.did)
                        assert(didJwk1.keyId != didJwk2.keyId)
                    } catch {
                        XCTFail("\(error)")
                    }
                }
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
