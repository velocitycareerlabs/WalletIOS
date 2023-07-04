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
    var keyService: KeyService!

    override func setUp() {
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl(secretStore: SecretStoreMock.Instance))
            ),
            EmptyExecutor()
        )
        keyService = KeyServiceImpl(secretStore: SecretStoreMock.Instance)
    }
    
    func testSign() {
        var resultJwt: VCLResult<VCLJwt>? = nil

        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            )
        ) {
            resultJwt = $0
        }

        do {
            guard let jwt = try resultJwt?.get() else {
                XCTFail()
                return
            }
            assert(jwt.header?["alg"] as? String == "ES256K")
            assert(((jwt.header?["jwk"] as? [String: Any])?["crv"] as? String) == "secp256k1")
            assert(jwt.header?["typ"] as? String == "JWT")
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSignVerify() {
        var resultJwt: VCLResult<VCLJwt>? = nil
        var resultVerified: VCLResult<Bool>? = nil

        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            )
        ) {
            resultJwt = $0
        }

        do {
            guard let jwt = try resultJwt?.get() else {
                XCTFail()
                return
            }
            subject.verifyJwt(jwt: jwt, jwkPublic: VCLJwkPublic(valueDict: (jwt.jwsToken!.headers.jsonWebKey?.toDictionaryOpt())!)) {
                resultVerified = $0
            }
            guard let isVerified = try resultVerified?.get() else {
                XCTFail()
                return
            }
            assert(isVerified)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testSignByExistingKey() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                var resultJwt: VCLResult<VCLJwt>? = nil
                var resultVerified: VCLResult<Bool>? = nil
                
                self!.subject.generateSignedJwt(
                    jwtDescriptor: VCLJwtDescriptor(
                        keyId: didJwk.keyId,
                        payload: JwtServiceMocks.Json.toDictionary()!,
                        jti: "some jti",
                        iss: "some iss"
                    )
                ) {
                    resultJwt = $0
                }
                guard let jwt = try resultJwt?.get() else {
                    XCTFail()
                    return
                }
                self!.subject.verifyJwt(jwt: jwt, jwkPublic: VCLJwkPublic(valueDict: (jwt.jwsToken!.headers.jsonWebKey?.toDictionaryOpt())!)) {
                    resultVerified = $0
                }
                guard let isVerified = try resultVerified?.get() else {
                    XCTFail()
                    return
                }
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
                
            }
        }
    }
    
    override class func tearDown() {
    }
}
