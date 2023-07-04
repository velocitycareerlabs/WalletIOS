//
//  JwtServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class JwtServiceTest: XCTestCase {
    
    var subject: JwtServiceImpl!
    
    var didJwk: VCLDidJwk!
    let keyService = KeyServiceImpl(secretStore: SecretStoreMock.Instance)
    
    let payloadMock = "{\"key1\":\"value1\",\"key2\":\"value2\"}".toDictionary()!
    private let jtiMock = "some jti"
    private let issMock = "some iss"
    private let audMock = "some sud"
    private let nonceMock = "some nonce"
    
    private let sevenDaysInSeconds: Double = 7 * 24 * 60 * 60
    
    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self!.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        subject = JwtServiceImpl(keyService)
    }
    
    func testSignFullParams() {
        subject.sign(
            kid: didJwk.kid,
            nonce: nonceMock,
            jwtDescriptor: VCLJwtDescriptor(
                keyId: didJwk.keyId,
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid == self!.didJwk.kid)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == self!.nonceMock)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignPartParams1() {
        subject.sign(
            nonce: nonceMock,
            jwtDescriptor: VCLJwtDescriptor(
                keyId: didJwk.keyId,
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == self!.nonceMock)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignPartParams2() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                keyId: didJwk.keyId,
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignPartParams3() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                iss: issMock,
                aud: audMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert((jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignPartParams4() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                iss: issMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == nil)
                assert((jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSignPartParams5() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                iss: issMock
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyAud] as? String == nil)
                assert((jwt.payload?[JwtServiceImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[JwtServiceImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[JwtServiceImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[JwtServiceImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self!.sevenDaysInSeconds)
                assert(jwt.payload?[JwtServiceImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
