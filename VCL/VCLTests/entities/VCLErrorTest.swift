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
    
    func testErrorFromError1() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode
        )
        let errorFromError = VCLError(error: error)
        
        assert(error.payload == errorFromError.payload)
        assert(error.error == errorFromError.error)
        assert(error.errorCode == errorFromError.errorCode)
        assert(error.message == errorFromError.message)
        assert(error.statusCode == errorFromError.statusCode)
    }
    
    func testErrorFromError2() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            message: ErrorMocks.Message
        )
        let errorFromError = VCLError(error: error)
        
        assert(errorFromError.payload == error.payload)
        assert(errorFromError.error == error.error)
        assert(errorFromError.errorCode == error.errorCode)
        assert(errorFromError.message == error.message)
    }

    func testErrorToJsonFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        let errorDictionary = error.toDictionary()

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == ErrorMocks.Payload)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
    }

    func testErrorToJsonFromProperties() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            message: ErrorMocks.Message,
            statusCode : ErrorMocks.StatusCode
        )
        let errorDictionary = error.toDictionary()

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == nil)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
    }
}

