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

    func testVerifyPresentationRequestSuccess() {
        subject = PresentationRequestByDeepLinkVerifierImpl()
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLink,
            didDocument: DidDocumentMocks.DidDocumentMock
        ) { verificationResult in
            do {
                try verificationResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyPresentationRequestSuccessWithDidDocumentIdInDeepLink() {
        subject = PresentationRequestByDeepLinkVerifierImpl()
        let deepLinkWithDidDocumentId = deepLinkWithInspectorDid(DidDocumentMocks.DidDocumentMock.id)

        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLinkWithDidDocumentId,
            didDocument: DidDocumentMocks.DidDocumentMock
        ) { verificationResult in
            do {
                try verificationResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyPresentationRequestSuccessWithDidDocumentIdInPresentationRequest() {
        subject = PresentationRequestByDeepLinkVerifierImpl()

        let originalDidDocumentId = DidDocumentMocks.DidDocumentMock.id
        var didDocumentPayload = DidDocumentMocks.DidDocumentMock.payload
        didDocumentPayload[VCLDidDocument.CodingKeys.KeyId] = presentationRequest.iss

        var alsoKnownAs = DidDocumentMocks.DidDocumentMock.alsoKnownAs
        if !alsoKnownAs.contains(originalDidDocumentId) {
            alsoKnownAs.append(originalDidDocumentId)
        }
        didDocumentPayload[VCLDidDocument.CodingKeys.KeyAlsoKnownAs] = alsoKnownAs

        let didDocumentWithPresentationRequestIss = VCLDidDocument(payload: didDocumentPayload)
        let deepLinkWithDidDocumentAlias = deepLinkWithInspectorDid(originalDidDocumentId)

        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLinkWithDidDocumentAlias,
            didDocument: didDocumentWithPresentationRequestIss
        ) { verificationResult in
            do {
                try verificationResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyPresentationRequestError() {
        subject = PresentationRequestByDeepLinkVerifierImpl()
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLink,
            didDocument: DidDocumentMocks.DidDocumentWithWrongDidMock
        ) { verificationResult in
            do {
                try verificationResult.get()
                XCTFail( "\(VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)
            }
        }
    }

    private func deepLinkWithInspectorDid(_ inspectorDid: String) -> VCLDeepLink {
        let encodedInspectorDid = inspectorDid.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? inspectorDid
        return VCLDeepLink(value: "velocity-network://inspect?inspectorDid=\(encodedInspectorDid)")
    }
}
