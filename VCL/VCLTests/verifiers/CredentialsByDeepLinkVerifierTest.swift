//
//  CredentialsByDeepLinkVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class CredentialsByDeepLinkVerifierTest: XCTestCase {
    private let subject = CredentialsByDeepLinkVerifierImpl()

    private let correctDeepLink =
    VCLDeepLink(value: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiBMsw27IKRYIdwUOfDeBd0LnWVeG2fPxxJi9L1fvjM20g%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition%26issuerDid%3Ddid%3Aion%3AEiBMsw27IKRYIdwUOfDeBd0LnWVeG2fPxxJi9L1fvjM20g")
    private let wrongDeepLink = DeepLinkMocks.CredentialManifestDeepLinkDevNet

    func testVerifyCredentialsSuccess() {
        subject.verifyCredentials(
            jwtCredentials: [
                    VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer),
                    VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer)
                ],
            deepLink: correctDeepLink
        ) { isVerifiedRes in
            do {
                let isVerified = try isVerifiedRes.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyCredentialsError() {
        subject.verifyCredentials(
            jwtCredentials: [
                VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer),
                VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer)
            ],
            deepLink: wrongDeepLink
        ) { isVerifiedRes in
            do {
                _ = try isVerifiedRes.get()
                XCTFail("\(VCLErrorCode.MismatchedCredentialIssuerDid.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.MismatchedCredentialIssuerDid.rawValue)
            }
        }
    }
}
