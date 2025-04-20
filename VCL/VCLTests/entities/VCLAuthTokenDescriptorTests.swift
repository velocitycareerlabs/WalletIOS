//
//  VCLAuthTokenDescriptorTests.swift
//  VCL
//
//  Created by Michael Avoyan on 17/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLAuthTokenDescriptorTests: XCTestCase {

    private let authTokenUri = "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:web:devregistrar.velocitynetwork.foundation:d:example-21.com-8b82ce9a/oauth/token"
    private let walletDid = "did:jwk:eyJrdHkiOiJFQyIsInVzZSI6InNpZyIsImNydiI6InNlY3AyNTZrMSIsImtpZCI6IjNkODdhZGFmLWQ0ZmEtNDBkZS1iNGYzLTExNGFhOGZmOTMyOCIsIngiOiJvZThGN1ZPWmtOZGpnUTNLdHVmenlwRjBkTWh2QjZVanpYQVRVQ1d2NlRjIiwieSI6IjRQNFZJRFJtYWM2ZlJFY0hkR2tDdVRqdDJMSnNoYVZ2WWpjMGVVZEdpaHcifQ"
    private let relyingPartyDid = "did:web:devregistrar.velocitynetwork.foundation:d:example-21.com-8b82ce9a"
    private let vendorOriginContext = "vendor-context"
    private let refreshToken = VCLToken(jwtValue: TokenMocks.TokenJwt1)

    func testInitWithPresentationRequestAndOptionalParameters() {
        let descriptor = VCLAuthTokenDescriptor(
            presentationRequest: PresentationRequestMocks.PresentationRequestFeed,
            refreshToken: refreshToken
        )

        XCTAssertEqual(descriptor.authTokenUri, authTokenUri)
        XCTAssertEqual(descriptor.walletDid, walletDid)
        XCTAssertEqual(descriptor.relyingPartyDid, relyingPartyDid)
        XCTAssertNil(descriptor.vendorOriginContext)
        XCTAssertEqual(descriptor.refreshToken?.value, refreshToken.value)
    }

    func testInitWithPresentationRequestOnly() {
        let descriptor = VCLAuthTokenDescriptor(presentationRequest: PresentationRequestMocks.PresentationRequestFeed)

        XCTAssertEqual(descriptor.authTokenUri, authTokenUri)
        XCTAssertEqual(descriptor.walletDid, walletDid)
        XCTAssertEqual(descriptor.relyingPartyDid, relyingPartyDid)
        XCTAssertNil(descriptor.vendorOriginContext)
        XCTAssertNil(descriptor.refreshToken)
    }

    func testInitWithAllManualParams() {
        let descriptor = VCLAuthTokenDescriptor(
            authTokenUri: authTokenUri,
            refreshToken: refreshToken,
            walletDid: walletDid,
            relyingPartyDid: relyingPartyDid,
            vendorOriginContext: vendorOriginContext
        )

        XCTAssertEqual(descriptor.authTokenUri, authTokenUri)
        XCTAssertEqual(descriptor.walletDid, walletDid)
        XCTAssertEqual(descriptor.relyingPartyDid, relyingPartyDid)
        XCTAssertEqual(descriptor.vendorOriginContext, vendorOriginContext)
        XCTAssertEqual(descriptor.refreshToken?.value, refreshToken.value)
    }

    func testGenerateRequestBodyForRefreshTokenOnly() {
        let descriptor = VCLAuthTokenDescriptor(
            authTokenUri: authTokenUri,
            refreshToken: refreshToken,
            walletDid: walletDid,
            relyingPartyDid: relyingPartyDid,
            vendorOriginContext: nil
        )

        let expected = [
            VCLAuthTokenDescriptor.CodingKeys.KeyGrantType: GrantType.RefreshToken.rawValue,
            VCLAuthTokenDescriptor.CodingKeys.KeyClientId: walletDid,
            GrantType.RefreshToken.rawValue: refreshToken.value,
            VCLAuthTokenDescriptor.CodingKeys.KeyAudience: relyingPartyDid
        ]
        
        XCTAssertTrue(descriptor.generateRequestBody() == expected)
    }

    func testGenerateRequestBodyForVendorOriginContextOnly() {
        let descriptor = VCLAuthTokenDescriptor(
            authTokenUri: authTokenUri,
            refreshToken: nil,
            walletDid: walletDid,
            relyingPartyDid: relyingPartyDid,
            vendorOriginContext: vendorOriginContext
        )

        let expected = [
            VCLAuthTokenDescriptor.CodingKeys.KeyGrantType: GrantType.AuthorizationCode.rawValue,
            VCLAuthTokenDescriptor.CodingKeys.KeyClientId: walletDid,
            GrantType.AuthorizationCode.rawValue: vendorOriginContext,
            VCLAuthTokenDescriptor.CodingKeys.KeyAudience: relyingPartyDid,
            VCLAuthTokenDescriptor.CodingKeys.KeyTokenType: VCLAuthTokenDescriptor.CodingKeys.KeyTokenTypeValue
        ]

        XCTAssertTrue(descriptor.generateRequestBody() == expected)
    }

    func testGenerateRequestBodyWithBothRefreshTokenAndVendorOriginContext() {
        let descriptor = VCLAuthTokenDescriptor(
            authTokenUri: authTokenUri,
            refreshToken: refreshToken,
            walletDid: walletDid,
            relyingPartyDid: relyingPartyDid,
            vendorOriginContext: vendorOriginContext
        )

        let expected = [
            VCLAuthTokenDescriptor.CodingKeys.KeyGrantType: GrantType.RefreshToken.rawValue,
            VCLAuthTokenDescriptor.CodingKeys.KeyClientId: walletDid,
            GrantType.RefreshToken.rawValue: refreshToken.value,
            VCLAuthTokenDescriptor.CodingKeys.KeyAudience: relyingPartyDid
        ]

        XCTAssertTrue(descriptor.generateRequestBody() == expected)
    }
}

