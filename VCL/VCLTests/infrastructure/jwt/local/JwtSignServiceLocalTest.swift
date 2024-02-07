//
//  JwtSignServiceLocalTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class JwtSignServiceLocalTest: XCTestCase {
    private var subject: VCLJwtSignService!

    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    private let payloadMock = "{\"key1\":\"value1\",\"key2\":\"value2\"}".toDictionary()
    private let jtiMock = "some jti"
    private let issMock = "some iss"
    private let audMock = "some sud"
    private let nonceMock = "some nonce"
    
    private let sevenDaysInSeconds: Double = 7 * 24 * 60 * 60

    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        subject = VCLJwtSignServiceLocalImpl(keyService)
    }

    func testSignFullParams() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            ),
            nonce: nonceMock,
            didJwk: didJwk
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid == self?.didJwk.kid)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == self!.nonceMock)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testSignPartialParams1() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            ),
            nonce: nonceMock,
            didJwk: didJwk
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == self!.nonceMock)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testSignPartialParams2() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            ),
            didJwk: didJwk
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String == self!.jtiMock)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testSignPartialParams3() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                iss: issMock,
                aud: audMock
            ),
            didJwk: didJwk
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == self!.audMock)
                assert((jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testSignPartialParams4() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                iss: issMock
            ),
            didJwk: didJwk
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == nil)
                assert((jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testSignPartParams5() {
        subject.sign(
            jwtDescriptor: VCLJwtDescriptor(
                iss: issMock
            ),
            didJwk: didJwk

        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid?.isEmpty == false)
                
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIss] as? String == self!.issMock)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyAud] as? String == nil)
                assert((jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyJti] as? String)?.isEmpty == false)
                let iat = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyIat] as! Double
                let nbf = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNbf] as! Double
                let exp = jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyExp] as! Double
                assert(iat == nbf)
                assert(exp - iat == self?.sevenDaysInSeconds)
                assert(jwt.payload?[VCLJwtSignServiceLocalImpl.CodingKeys.KeyNonce] as? String == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
