//
//  CredentialManifestByDeepLinkVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class CredentialManifestByDeepLinkVerifierTest: XCTestCase {
    private var subject: CredentialManifestByDeepLinkVerifier!
    
    private let credentialManifest = VCLCredentialManifest(
        jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifest1),
        verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfRegularIssuer.toDictionary()!),
        didJwk: DidJwkMocks.DidJwk
    )
    private let deepLink = DeepLinkMocks.CredentialManifestDeepLinkDevNet

    func testVerifyCredentialManifestSuccess() {
        subject = CredentialManifestByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentMockStr)
            )
        )
        
        subject.verifyCredentialManifest(
            credentialManifest: credentialManifest,
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
                       

    func testVerifyCredentialManifestError() {
        subject = CredentialManifestByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentWithWrongDidMockStr)
            )
        )
        
        subject.verifyCredentialManifest(
            credentialManifest: credentialManifest,
            deepLink: deepLink
        ) { isVerifiedRes in
            do {
                _ = try isVerifiedRes.get()
                XCTFail("\(VCLErrorCode.MismatchedRequestIssuerDid.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.MismatchedRequestIssuerDid.rawValue)
            }
        }
    }
}
