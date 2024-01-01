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

    private let correctDeepLink = DeepLinkMocks.PresentationRequestDeepLinkDevNet
    private let wrongDeepLink = VCLDeepLink(
        value: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f163056%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc%26inspectorDid%3Ddid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f163056%26vendorOriginContext%3D%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22%2C%22KeyCode%22%3A%2254514480%22%7D%2C%22Token%22%3A%22832077a4%22%7D"
    )

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
