//
//  VCLErrorTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 08/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLErrorTes: XCTestCase {

    func testErrorFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)

        assert(error.payload == ErrorMocks.Payload)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
    }

    func testErrorFromProperties() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode
        )

        assert(error.payload == nil)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
    }
}

