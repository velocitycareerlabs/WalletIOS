//
//  PresentationRequestByDeepLinkVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class PresentationRequestByDeepLinkVerifierTest: XCTestCase {
    
    private var subject: PresentationRequestByDeepLinkVerifier!
    
    private let presentationRequest = PresentationRequestMocks.PresentationRequest

    private let deepLink = DeepLinkMocks.PresentationRequestDeepLinkDevNet

    func testVerifyCredentialManifestSuccess() {
        subject = PresentationRequestByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentMockStr)
            )
        )
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
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
        subject = PresentationRequestByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentWithWrongDidMockStr)
            )
        )
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLink
        ) { isVerifiedRes in
            do {
                _ = try isVerifiedRes.get()
                XCTFail( "\(VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)
            }
        }
    }
}
