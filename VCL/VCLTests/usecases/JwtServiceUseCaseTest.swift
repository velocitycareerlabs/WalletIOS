//
//  JwtServiceUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/06/2021.
//

import Foundation
import VCToken
import VCCrypto
import XCTest
@testable import VCL

final class JwtServiceUseCaseTest: XCTestCase {
    
    var subject: JwtServiceUseCase!

    override func setUp() {
    }
    
    func testGetCredentialManifest() {
        // Arrange
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
//                Can't be tested, because of storing exception 
//                JwtServiceMicrosoftImpl()
                JwtServiceSuccess(VclJwt: VCLJWT(encodedJwt: JwtServiceMocks.SignedJwt))
            ),
            EmptyExecutor()
        )
        let iss = "some iss"
        var resultJwt: VCLResult<VCLJWT>? = nil
        var resultVerified: VCLResult<Bool>? = nil

        // Action
        subject.generateSignedJwt(payload: JwtServiceMocks.Json.toDictionary() ?? [String: String](), iss: iss) {
            resultJwt = $0
        }

        do {
            guard let jwt = try resultJwt?.get() else {
                XCTFail()
                return
            }
            // Remote API
            subject.verifyJwt(jwt: jwt, publicKey: VCLPublicKey(jwkDict: jwt.jwsToken!.headers.jsonWebKey!.toDictionary() as! [String: String])) {
                resultVerified = $0
            }
            // Verification actual algorithm
            let isVerified = try jwt.jwsToken?.verify(using: Secp256k1Verifier(), withPublicKey: jwt.jwsToken!.headers.jsonWebKey!) == true
            
            // Assert both have the same result
            guard let remoteIsVerified = try resultVerified?.get() else {
                XCTFail()
                return
            }
            assert(remoteIsVerified == isVerified)
        } catch {
            XCTFail()
        }
    }
    
    override class func tearDown() {
    }
}
