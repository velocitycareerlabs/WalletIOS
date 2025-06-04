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
    private var subject: CredentialsByDeepLinkVerifier!

    private let deepLink = DeepLinkMocks.CredentialManifestDeepLinkDevNet

    func testVerifyCredentialsSuccess() {
        subject = CredentialsByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentMockStr)
            )
        )
        
        subject.verifyCredentials(
            jwtCredentials: [
                    VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer),
                    VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer)
                ],
            deepLink: deepLink
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
        subject = CredentialsByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentWithWrongDidMockStr)
            )
        )
        
        subject.verifyCredentials(
            jwtCredentials: [
                VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer),
                VCLJwt(encodedJwt: CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer)
            ],
            deepLink: deepLink
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
