//
//  JwtServiceUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class JwtServiceUseCaseTest: XCTestCase {
    
    var subject: JwtServiceUseCase!
    var keyService: VCLKeyService!
    
    override func setUp() {
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            ExecutorImpl()
        )
        keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    }
    
    func testSign() {
        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            ),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let jwt = try $0.get()
                assert(jwt.header?["alg"] as? String == "ES256K")
                assert(((jwt.header?["jwk"] as? [String: Any])?["crv"] as? String) == "secp256k1")
                assert(jwt.header?["typ"] as? String == "JWT")
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignVerify() {
        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            ),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let jwt = try $0.get()
                self.subject.verifyJwt(
                    jwt: jwt,
                    publicJwk: VCLPublicJwk(valueDict: jwt.jwsToken?.headers.jsonWebKey?.toDictionary() ?? [:]),
                    remoteCryptoServicesToken: nil
                ) {
                    do {
                        let isVerivied = try $0.get()
                        assert(isVerivied)
                    } catch {
                        XCTFail("\(error)")
                    }
                }
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignByExistingKey() {
        keyService.generateDidJwk(remoteCryptoServicesToken: nil) { [weak self] didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                self!.subject.generateSignedJwt(
                    jwtDescriptor: VCLJwtDescriptor(
                        keyId: didJwk.keyId,
                        payload: JwtServiceMocks.Json.toDictionary()!,
                        jti: "some jti",
                        iss: "some iss"
                    ),
                    remoteCryptoServicesToken: nil
                ) {
                    do {
                        let jwt = try $0.get()
                        self!.subject.verifyJwt(
                            jwt: jwt,
                            publicJwk: VCLPublicJwk(valueDict: jwt.jwsToken?.headers.jsonWebKey?.toDictionary() ?? [:]),
                            remoteCryptoServicesToken: nil
                        ) {
                            do {
                                let isVerified = try $0.get()
                                assert(isVerified)
                            } catch {
                                XCTFail("\(error)")
                            }
                        }
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
