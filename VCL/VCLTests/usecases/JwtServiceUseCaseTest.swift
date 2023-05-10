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

    override func setUp() {
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                JwtServiceImpl(secretStore: SecretStoreMock())
            ),
            EmptyExecutor()
        )
    }
    
    func testSign() {
        var resultJwt: VCLResult<VCLJwt>? = nil

        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](),
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
                payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](),
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
            subject.verifyJwt(jwt: jwt, jwkPublic: VCLJwkPublic(valueDict: jwt.jwsToken!.headers.jsonWebKey!.toDictionary() as [String: Any])) {
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
        var resultDidJwk: VCLResult<VCLDidJwk>? = nil

        subject.generateDidJwk {
            resultDidJwk = $0
        }
        do {
            guard let didJwk = try resultDidJwk?.get() else {
                XCTFail()
                return
            }
            var resultJwt: VCLResult<VCLJwt>? = nil
            subject.generateSignedJwt(
                jwtDescriptor: VCLJwtDescriptor(
                    keyId: didJwk.keyId,
                    payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](),
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
            assert(jwt.keyId == didJwk.keyId)
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
            assert(didJwk1.didJwk.hasPrefix(VCLDidJwk.DidJwkPrefix))
            assert(didJwk2.didJwk.hasPrefix(VCLDidJwk.DidJwkPrefix))
            assert(didJwk1.didJwk != didJwk2.didJwk)
            assert(didJwk1.keyId != didJwk2.keyId)
        } catch {
            XCTFail("\(error)")

        }
    }
    
    override class func tearDown() {
    }
}
