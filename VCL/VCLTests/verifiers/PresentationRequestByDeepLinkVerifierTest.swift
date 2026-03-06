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
        subject = PresentationRequestByDeepLinkVerifierImpl()
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLink,
            didDocument: DidDocumentMocks.DidDocumentMock
        ) { isVerifiedRes in
            do {
                let isVerified = try isVerifiedRes.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyCredentialManifestSuccessWithDidDocumentIdInDeepLink() {
        subject = PresentationRequestByDeepLinkVerifierImpl()
        let deepLinkWithDidDocumentId = deepLinkWithInspectorDid(DidDocumentMocks.DidDocumentMock.id)

        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLinkWithDidDocumentId,
            didDocument: DidDocumentMocks.DidDocumentMock
        ) { isVerifiedRes in
            do {
                let isVerified = try isVerifiedRes.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyCredentialManifestSuccessWithDidDocumentIdInPresentationRequest() {
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
        subject = PresentationRequestByDeepLinkVerifierImpl()
        
        subject.verifyPresentationRequest(
            presentationRequest: presentationRequest,
            deepLink: deepLink,
            didDocument: DidDocumentMocks.DidDocumentWithWrongDidMock
        ) { isVerifiedRes in
            do {
                _ = try isVerifiedRes.get()
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
