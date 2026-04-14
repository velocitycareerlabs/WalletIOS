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

class VCLErrorTest: XCTestCase {
    private struct DummyError: Error, CustomStringConvertible {
        let description: String
    }
    
    func testErrorFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        
        assert(error.payload == ErrorMocks.Payload)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.requestId == ErrorMocks.RequestId)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
        assert(error.cause == nil)
        assert(error.callStackSymbols?.isEmpty == false)
    }
    
    func testErrorFromProperties() {
        let cause = DummyError(description: "manual cause")
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode,
            cause: cause
        )
        
        assert(error.payload == nil)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.requestId == ErrorMocks.RequestId)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
        assert((error.cause as? DummyError)?.description == cause.description)
        assert(error.callStackSymbols?.isEmpty == false)
    }
    
    func testErrorFromError1() {
        let cause = DummyError(description: "wrapped cause")
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode,
            cause: cause
        )
        let errorFromError = VCLError(error: error)
        
        assert(error.payload == errorFromError.payload)
        assert(error.error == errorFromError.error)
        assert(error.errorCode == errorFromError.errorCode)
        assert(error.requestId == errorFromError.requestId)
        assert(error.message == errorFromError.message)
        assert(error.statusCode == errorFromError.statusCode)
        assert((errorFromError.cause as? DummyError)?.description == cause.description)
        assert(error.callStackSymbols == errorFromError.callStackSymbols)
    }
    
    func testErrorFromError2() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message
        )
        let errorFromError = VCLError(error: error)
        
        assert(errorFromError.payload == error.payload)
        assert(errorFromError.error == error.error)
        assert(errorFromError.errorCode == error.errorCode)
        assert(errorFromError.requestId == error.requestId)
        assert(errorFromError.message == error.message)
    }
    
    func testErrorFromNonVCLErrorDoesNotWrapOptionalInMessage() {
        let error = VCLError(error: DummyError(description: "dummy failure"))
        
        assert(error.message == "dummy failure")
        assert((error.cause as? DummyError)?.description == "dummy failure")
        assert(error.callStackSymbols?.isEmpty == false)
    }

    func testErrorFromNonVCLErrorUsesWrappedErrorAsCause() {
        let underlyingError = VCLError(error: DummyError(description: "underlying failure"))
        let wrappedNSError = NSError(
            domain: "test",
            code: 1,
            userInfo: [NSUnderlyingErrorKey: underlyingError]
        )
        let error = VCLError(error: wrappedNSError)

        assert((error.cause as NSError?)?.domain == "test")
        assert((error.cause as NSError?)?.userInfo[NSUnderlyingErrorKey] as? VCLError != nil)
    }

    func testErrorToJsonFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        let errorDictionary = error.toDictionary()
        let callStackSymbols = errorDictionary[VCLError.CodingKeys.KeyCallStackSymbols] as? [String]

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == ErrorMocks.Payload)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyRequestId] as? String == ErrorMocks.RequestId)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
        assert(callStackSymbols?.isEmpty == false)
    }

    func testErrorToJsonFromProperties() {
        let cause = DummyError(description: "manual cause")
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode : ErrorMocks.StatusCode,
            cause: cause
        )
        let errorDictionary = error.toDictionary()
        let callStackSymbols = errorDictionary[VCLError.CodingKeys.KeyCallStackSymbols] as? [String]

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == nil)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyRequestId] as? String == ErrorMocks.RequestId)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
        assert(callStackSymbols == error.callStackSymbols)
    }
}
