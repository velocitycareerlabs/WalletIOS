//
//  JwtServiceUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCToken
@testable import VCCrypto
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
    
    func testSignVerify() {
        var resultJwt: VCLResult<VCLJwt>? = nil
        var resultVerified: VCLResult<Bool>? = nil

        // Action
        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](),
                jti: "",
                iss: ""
            )
        ) {
            resultJwt = $0
        }

        do {
            guard let jwt = try resultJwt?.get() else {
                XCTFail()
                return
            }
            // Remote API
            subject.verifyJwt(jwt: jwt, jwkPublic: VCLJwkPublic(valueDict: jwt.jwsToken!.headers.jsonWebKey!.toDictionary() as [String: Any])) {
                resultVerified = $0
            }
            // Assert both have the same result
            guard let isVerified = try resultVerified?.get() else {
                XCTFail()
                return
            }
            assert(isVerified)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGenerateDidJwk() {
        var resultDidJwk1: VCLResult<VCLDidJwk>? = nil
        var resultDidJwk2: VCLResult<VCLDidJwk>? = nil

        subject.generateDidJwk(didJwkDescriptor: VCLDidJwkDescriptor(kid: CommonMocks.UUID1)) {
            resultDidJwk1 = $0
        }
        subject.generateDidJwk(didJwkDescriptor: VCLDidJwkDescriptor(kid: CommonMocks.UUID1)) {
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
            assert(didJwk1.didJwk == didJwk2.didJwk)
        } catch {
            XCTFail("\(error)")

        }
    }
    
    override class func tearDown() {
    }
}
