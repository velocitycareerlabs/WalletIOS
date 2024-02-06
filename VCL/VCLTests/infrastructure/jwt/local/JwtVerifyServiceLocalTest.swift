//
//  JwtVerifyServiceLocalTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/10/2023.
//

import Foundation
import XCTest
@testable import VCL

class JwtVerifyServiceLocalTest: XCTestCase {
    private var subject: VCLJwtVerifyService!
    private var jwtSignService: VCLJwtSignService!
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    private let payloadMock = "{\"key1\":\"value1\",\"key2\":\"value2\"}".toDictionary()
    private let jtiMock = "some jti"
    private let issMock = "some iss"
    private let audMock = "some sud"
    private let nonceMock = "some nonce"
        
    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self!.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        subject = VCLJwtVerifyServiceLocalImpl()
        jwtSignService = VCLJwtSignServiceLocalImpl(keyService)
    }
    
    func testSignAndVerify() {
        jwtSignService.sign(
            didJwk: didJwk,
            nonce: nonceMock,
            jwtDescriptor: VCLJwtDescriptor(
                payload: payloadMock,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            )
        ) { jwtResult in
            do {
                let jwt = try jwtResult.get()
                assert(jwt.kid == self.didJwk.kid)
                
                self.subject.verify(jwt: jwt, publicJwk: self.didJwk.publicJwk, remoteCryptoServicesToken: nil) { verifiedResult in
                    do {
                        let verified = try verifiedResult.get()
                        assert(verified, "failed to verify jwt: \(verified)")
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
