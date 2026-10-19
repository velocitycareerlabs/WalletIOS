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
    
    private var subject: JwtServiceUseCase!
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    
    override func setUp() {
        keyService.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
        ) { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        
        subject = JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            EmptyExecutor()
        )
    }
    
    func testSign() {
        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            ),
            didJwk: didJwk,
            remoteCryptoServicesToken: nil
        ) {
            do {
                let jwt = try $0.get()
                assert(jwt.header?["alg"] as? String == VCLSignatureAlgorithm.SECP256k1.jwsAlgorithm)
                assert(((jwt.header?["jwk"] as? [String: Any])?["crv"] as? String) == VCLSignatureAlgorithm.SECP256k1.rawValue)
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
            didJwk: didJwk,
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
        keyService.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.SECP256k1)
        ) { [weak self] didJwkResult in
            do {
                let didJwk = try didJwkResult.get()
                
                self!.subject.generateSignedJwt(
                    jwtDescriptor: VCLJwtDescriptor(
                        payload: JwtServiceMocks.Json.toDictionary()!,
                        jti: "some jti",
                        iss: "some iss"
                    ),
                    didJwk: didJwk,
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

    func testSignVerifyEs256WithP256Key() throws {
        var didJwkResult: VCLResult<VCLDidJwk> = .failure(VCLError(message: "generateDidJwk did not complete"))
        keyService.generateDidJwk(
            didJwkDescriptor: VCLDidJwkDescriptor(signatureAlgorithm: VCLSignatureAlgorithm.ES256)
        ) { didJwkResult = $0 }
        let didJwk = try didJwkResult.get()

        var jwtResult: VCLResult<VCLJwt> = .failure(VCLError(message: "generateSignedJwt did not complete"))
        subject.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                payload: JwtServiceMocks.Json.toDictionary()!,
                jti: "some jti",
                iss: "some iss"
            ),
            didJwk: didJwk,
            remoteCryptoServicesToken: nil
        ) { jwtResult = $0 }
        let jwt = try jwtResult.get()

        XCTAssertEqual(jwt.header?["alg"] as? String, VCLSignatureAlgorithm.ES256.jwsAlgorithm)
        XCTAssertEqual((jwt.header?["jwk"] as? [String: Any])?["crv"] as? String, VCLSignatureAlgorithm.ES256.curve)
        XCTAssertEqual(jwt.header?["kid"] as? String, didJwk.kid)
        XCTAssertEqual(jwt.header?["typ"] as? String, "JWT")

        var verifiedResult: VCLResult<Bool> = .failure(VCLError(message: "verifyJwt did not complete"))
        subject.verifyJwt(jwt: jwt, publicJwk: didJwk.publicJwk, remoteCryptoServicesToken: nil) { verifiedResult = $0 }
        XCTAssertTrue(try verifiedResult.get())
    }
}
