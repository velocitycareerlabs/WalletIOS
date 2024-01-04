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
    private var subject: VCLSubmission!

    override func setUp() {
        subject = VCLPresentationSubmission(
            presentationRequest: PresentationSubmissionMocks.PresentationRequest,
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
        )
    }

    func testPayload() {
        assert(subject.payload[VCLSubmission.CodingKeys.KeyJti] as! String == subject.jti)
    }

    func testPushDelegate() {
        assert(subject.pushDelegate!.pushUrl == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(subject.pushDelegate!.pushToken == PresentationSubmissionMocks.PushDelegate.pushToken)
    }

    func testRequestBody() {
        let requestBodyJsonObj = subject.generateRequestBody(jwt: JwtServiceMocks.JWT)
        assert(requestBodyJsonObj[VCLSubmission.CodingKeys.KeyExchangeId] as! String == subject.exchangeId)
        assert(requestBodyJsonObj[VCLSubmission.CodingKeys.KeyContext] as! [String] == VCLSubmission.CodingKeys.ValueContextList)

        let pushDelegateBodyJsonObj = requestBodyJsonObj[VCLSubmission.CodingKeys.KeyPushDelegate] as! [String: Any]

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as! String == PresentationSubmissionMocks.PushDelegate.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as! String == PresentationSubmissionMocks.PushDelegate.pushToken)

        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as! String == subject.pushDelegate!.pushUrl)
        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as! String == subject.pushDelegate!.pushToken)
    }
    
    func testContext() {
        assert(VCLSubmission.CodingKeys.KeyContext == "@context")
        assert(VCLSubmission.CodingKeys.ValueContextList == ["https://www.w3.org/2018/credentials/v1"])
    }
}
