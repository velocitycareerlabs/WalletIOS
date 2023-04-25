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

/// TODO: Need to mock MS lib storage
final class JwtServiceUseCaseTest: XCTestCase {
    
    var subject: JwtServiceUseCase!

    override func setUp() {
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                JwtServiceImpl()
            ),
            EmptyExecutor()
        )
    }
    
    func testSignVerify() {
//        var resultJwt: VCLResult<VCLJwt>? = nil
//        var resultVerified: VCLResult<Bool>? = nil
//
//        // Action
//        subject.generateSignedJwt(
//            jwtDescriptor: VCLJwtDescriptor(
//                payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](),
//                jti: "",
//                iss: ""
//            )
//        ) {
//            resultJwt = $0
//        }
//
//        do {
//            guard let jwt = try resultJwt?.get() else {
//                XCTFail()
//                return
//            }
//            // Remote API
//            subject.verifyJwt(jwt: jwt, jwkPublic: VCLJwkPublic(valueDict: jwt.jwsToken!.headers.jsonWebKey!.toDictionary() as! [String: String])) {
//                resultVerified = $0
//            }
//            // Assert both have the same result
//            guard let isVerified = try resultVerified?.get() else {
//                XCTFail()
//                return
//            }
//            assert(isVerified)
//        } catch {
//            XCTFail("\(error)")
//        }
    }
    
    func testGenerateDidJwk() {
//        var resultDidJwk: VCLResult<VCLDidJwk>? = nil
//
//        subject.generateDidJwk {
//            resultDidJwk = $0
//        }
//        do {
//            guard let didJwk = try resultDidJwk?.get() else {
//                XCTFail()
//                return
//            }
//            assert(didJwk.value.hasPrefix(VCLDidJwk.DidJwkPrefix))
//            assert(String(didJwk.value.suffix(VCLDidJwk.DidJwkPrefix.count)).decodeBase64()!.isEmpty == false)
//        } catch {
//            XCTFail("\(error)")
//
//        }
    }
    
    override class func tearDown() {
    }
}
