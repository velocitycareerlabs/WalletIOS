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

/// TODO: Test after updating Micrisoft jwt library
final class VCLSubmissionTest: XCTestCase {
    var subject: VCLSubmission!

    override func setUp() {
//        subject = VCLPresentationSubmission(
//            didJwk: JwtServiceMocks.didJwk,
//            presentationRequest: PresentationSubmissionMocks.PresentationRequest,
//            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
//        )
    }

    func testPayload() {
//        assert(subject.payload[VCLSubmission.CodingKeys.KeyJti] as! String == subject.jti)
    }

    func testPushDelegate() {
//        assert(subject.pushDelegate!.pushUrl == PresentationSubmissionMocks.PushDelegate.pushUrl)
//        assert(subject.pushDelegate!.pushToken == PresentationSubmissionMocks.PushDelegate.pushToken)
    }

    func testRequestBody() {
//        let requestBodyJsonObj = subject.generateRequestBody(jwt: JwtServiceMocks.JWT)
//        assert(requestBodyJsonObj[VCLSubmission.CodingKeys.KeyExchangeId] as! String == subject.exchangeId)
//
//        let pushDelegateBodyJsonObj = requestBodyJsonObj[VCLSubmission.CodingKeys.KeyPushDelegate] as! [String: Any]
//
//        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as! String == PresentationSubmissionMocks.PushDelegate.pushUrl)
//        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as! String == PresentationSubmissionMocks.PushDelegate.pushToken)
//
//        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushUrl] as! String == subject.pushDelegate!.pushUrl)
//        assert(pushDelegateBodyJsonObj[VCLPushDelegate.CodingKeys.KeyPushToken] as! String == subject.pushDelegate!.pushToken)
    }
}
