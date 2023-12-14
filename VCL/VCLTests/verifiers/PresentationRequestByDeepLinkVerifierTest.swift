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
    private let subject = PresentationRequestByDeepLinkVerifierImpl()
    private let presentationRequest = PresentationRequestMocks.PresentationRequest

    private let correctDeepLink =
    VCLDeepLink(value: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition%26issuerDid%3Ddid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692")
    private let wrongDeepLink = DeepLinkMocks.PresentationRequestDeepLinkDevNet

    func testVerifyCredentialManifestSuccess() {
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
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

    func testVerifyCredentialManifestError() {
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: wrongDeepLink
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
