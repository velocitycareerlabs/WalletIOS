//
//  VCLAuthTokenTest.swift
//  VCL
//
//  Created by Michael Avoyan on 17/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLAuthTokenTest: XCTestCase {

    var payload: [String: Any]!

    override func setUp() {
        super.setUp()
        payload = [
            "access_token": TokenMocks.TokenJwt1.encodedJwt,
            "refresh_token": TokenMocks.TokenJwt2.encodedJwt,
            "token_type": "Bearer",
            "authTokenUri": "https://default.uri",
            "walletDid": "did:wallet:default",
            "relyingPartyDid": "did:party:default"
        ]
    }

    func testShouldInitializeWithOnlyPayload() {
        let token = VCLAuthToken(payload: payload)

        XCTAssertEqual(token.accessToken.value, TokenMocks.TokenJwt1.encodedJwt)
        XCTAssertEqual(token.refreshToken.value, TokenMocks.TokenJwt2.encodedJwt)
        XCTAssertEqual(token.tokenType, "Bearer")
        XCTAssertEqual(token.authTokenUri, "https://default.uri")
        XCTAssertEqual(token.walletDid, "did:wallet:default")
        XCTAssertEqual(token.relyingPartyDid, "did:party:default")
    }

    func testShouldOverrideAuthTokenUriIfPassedInConstructor() {
        let token = VCLAuthToken(payload: payload, authTokenUri: "https://override.uri")
        XCTAssertEqual(token.authTokenUri, "https://override.uri")
    }

    func testShouldOverrideWalletDidIfPassedInConstructor() {
        let token = VCLAuthToken(payload: payload, walletDid: "did:wallet:override")
        XCTAssertEqual(token.walletDid, "did:wallet:override")
    }

    func testShouldOverrideRelyingPartyDidIfPassedInConstructor() {
        let token = VCLAuthToken(payload: payload, relyingPartyDid: "did:party:override")
        XCTAssertEqual(token.relyingPartyDid, "did:party:override")
    }
}
