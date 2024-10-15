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
    
    private let issuingIss = "issuing iss"
    private let inspectionIss = "inspection iss"

    override func setUp() {
        subjectPresentationSubmission = VCLPresentationSubmission(
            presentationRequest: PresentationSubmissionMocks.PresentationRequest,
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
        )
        
        subjectIdentificationSubmission = VCLIdentificationSubmission(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!),
                didJwk: DidJwkMocks.DidJwk
            ),
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
        )
    }

    func testPayload() {
        let presentationSubmissionPayload = subjectPresentationSubmission.generatePayload(iss: inspectionIss)
        assert(presentationSubmissionPayload[SubmissionCodingKeys.KeyJti] as? String == subjectPresentationSubmission.jti)
        assert(presentationSubmissionPayload[SubmissionCodingKeys.KeyIss] as? String == inspectionIss)

        let identificationSubmissionPayload = subjectIdentificationSubmission.generatePayload(iss: issuingIss)
        assert(identificationSubmissionPayload[SubmissionCodingKeys.KeyJti] as? String == subjectIdentificationSubmission.jti)
        assert(identificationSubmissionPayload[SubmissionCodingKeys.KeyIss] as? String == issuingIss)
    }

    func testPushDelegate() {
        assert(subjectPresentationSubmission.pushDelegate!.pushUrl == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(subjectPresentationSubmission.pushDelegate!.pushToken == PresentationSubmissionMocks.PushDelegate.pushToken)
    }

    func testRequestBody() {
        let requestBodyJsonObj = subjectPresentationSubmission.generateRequestBody(jwt: JwtServiceMocks.JWT)
        assert(requestBodyJsonObj[SubmissionCodingKeys.KeyExchangeId] as? String == subjectPresentationSubmission.exchangeId)
        assert(requestBodyJsonObj[SubmissionCodingKeys.KeyContext] as? [String] == SubmissionCodingKeys.ValueContextList)

        let pushDelegateBodyJsonObj = requestBodyJsonObj[SubmissionCodingKeys.KeyPushDelegate] as! [String: Sendable]

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as? String == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as? String == PresentationSubmissionMocks.PushDelegate.pushToken)

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as? String == subjectPresentationSubmission.pushDelegate!.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as? String == subjectPresentationSubmission.pushDelegate!.pushToken)
    }
    
    func testContext() {
        assert(SubmissionCodingKeys.KeyContext == "@context")
        assert(SubmissionCodingKeys.ValueContextList == ["https://www.w3.org/2018/credentials/v1"])
    }
}
