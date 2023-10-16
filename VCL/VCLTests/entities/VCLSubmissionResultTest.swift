//
//  VCLSubmissionResultTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 30/11/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLSubmissionResultTest: XCTestCase {
    var subject: VCLSubmissionResult!

    override func setUp() {
        subject = VCLSubmissionResult(
            sessionToken: VCLToken(value: "token123"),
            exchange: VCLExchange(
                id: "id123",
                type: "type123",
                disclosureComplete: true,
                exchangeComplete: true
            ),
            jti: "jti123",
            submissionId: "submissionId123"
        )
    }

    func testProps() {
        assert(subject.sessionToken.value == "token123")
        assert(subject.exchange.id == "id123")
        assert(subject.exchange.type == "type123")
        assert(subject.exchange.exchangeComplete == true)
        assert(subject.exchange.disclosureComplete == true)
        assert(subject.jti == "jti123")
        assert(subject.submissionId == "submissionId123")
    }
}
