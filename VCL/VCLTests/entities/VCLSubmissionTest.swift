//
//  VCLSubmissionTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLSubmissionTest: XCTestCase {
    private var subjectPresentationSubmission: VCLSubmission!
    private var subjectIdentificationSubmission: VCLSubmission!

    override func setUp() {
        subjectPresentationSubmission = VCLPresentationSubmission(
            presentationRequest: PresentationSubmissionMocks.PresentationRequest,
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList,
            iss: "inspection iss"
        )
        
        subjectIdentificationSubmission = VCLIdentificationSubmission(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
            ),
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList,
            iss: "issuing iss"
        )
    }

    func testPayload() {
        let pl = subjectPresentationSubmission.payload
        let iss = subjectPresentationSubmission.payload[VCLSubmission.CodingKeys.KeyIss] as? String
        assert(subjectPresentationSubmission.payload[VCLSubmission.CodingKeys.KeyJti] as? String == subjectPresentationSubmission.jti)
        assert(subjectPresentationSubmission.payload[VCLSubmission.CodingKeys.KeyIss] as? String == subjectPresentationSubmission.iss)

        assert(subjectIdentificationSubmission.payload[VCLSubmission.CodingKeys.KeyJti] as? String == subjectIdentificationSubmission.jti)
        assert(subjectIdentificationSubmission.payload[VCLSubmission.CodingKeys.KeyIss] as? String == subjectIdentificationSubmission.iss)
    }

    func testPushDelegate() {
        assert(subjectPresentationSubmission.pushDelegate!.pushUrl == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(subjectPresentationSubmission.pushDelegate!.pushToken == PresentationSubmissionMocks.PushDelegate.pushToken)
    }

    func testRequestBody() {
        let requestBodyJsonObj = subjectPresentationSubmission.generateRequestBody(jwt: JwtServiceMocks.JWT)
        assert(requestBodyJsonObj[VCLSubmission.CodingKeys.KeyExchangeId] as? String == subjectPresentationSubmission.exchangeId)
        assert(requestBodyJsonObj[VCLSubmission.CodingKeys.KeyContext] as? [String] == VCLSubmission.CodingKeys.ValueContextList)

        let pushDelegateBodyJsonObj = requestBodyJsonObj[VCLSubmission.CodingKeys.KeyPushDelegate] as! [String: Any]

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as? String == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as? String == PresentationSubmissionMocks.PushDelegate.pushToken)

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as? String == subjectPresentationSubmission.pushDelegate!.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as? String == subjectPresentationSubmission.pushDelegate!.pushToken)
    }
    
    func testContext() {
        assert(VCLSubmission.CodingKeys.KeyContext == "@context")
        assert(VCLSubmission.CodingKeys.ValueContextList == ["https://www.w3.org/2018/credentials/v1"])
    }
}
