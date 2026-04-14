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

    private let diagnostic = VCLError.Diagnostic(
        nativeErrorType: "NativeErrorType",
        nativeStackFrames: ["frame 1", "frame 2"],
        nativeStackTop: "frame 1",
        nativeCause: "NativeCause"
    )
    
    func testErrorFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        
        assert(error.payload == ErrorMocks.Payload)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.requestId == ErrorMocks.RequestId)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
        assert(error.diagnostic?.nativePlatform == VCLError.Diagnostic.CodingKeys.ValueNativePlatformIos)
        assert(error.diagnostic?.nativeErrorType == VCLError.CodingKeys.ValuePayloadDiagnosticType)
        assert(error.diagnostic?.nativeStackFrames?.isEmpty == false)
        assert(error.diagnostic?.nativeStackTop == error.diagnostic?.nativeStackFrames?.first)
        assert((error.diagnostic?.nativeStackFrames?.count ?? 0) <= VCLError.CodingKeys.MaxDiagnosticStackFrames)
    }
    
    func testErrorFromProperties() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode,
            diagnostic: diagnostic
        )
        
        assert(error.payload == nil)
        assert(error.error == ErrorMocks.Error)
        assert(error.errorCode == ErrorMocks.ErrorCode)
        assert(error.requestId == ErrorMocks.RequestId)
        assert(error.message == ErrorMocks.Message)
        assert(error.statusCode == ErrorMocks.StatusCode)
        assert(error.diagnostic?.nativePlatform == VCLError.Diagnostic.CodingKeys.ValueNativePlatformIos)
        assert(error.diagnostic?.nativeErrorType == diagnostic.nativeErrorType)
        assert(error.diagnostic?.nativeStackFrames == diagnostic.nativeStackFrames)
        assert(error.diagnostic?.nativeStackTop == diagnostic.nativeStackTop)
        assert(error.diagnostic?.nativeCause == diagnostic.nativeCause)
    }
    
    func testErrorFromError1() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode: ErrorMocks.StatusCode,
            diagnostic: diagnostic
        )
        let errorFromError = VCLError(error: error)
        
        assert(error.payload == errorFromError.payload)
        assert(error.error == errorFromError.error)
        assert(error.errorCode == errorFromError.errorCode)
        assert(error.requestId == errorFromError.requestId)
        assert(error.message == errorFromError.message)
        assert(error.statusCode == errorFromError.statusCode)
        assert(error.diagnostic?.nativePlatform == errorFromError.diagnostic?.nativePlatform)
        assert(error.diagnostic?.nativeErrorType == errorFromError.diagnostic?.nativeErrorType)
        assert(error.diagnostic?.nativeStackFrames == errorFromError.diagnostic?.nativeStackFrames)
        assert(error.diagnostic?.nativeStackTop == errorFromError.diagnostic?.nativeStackTop)
        assert(error.diagnostic?.nativeCause == errorFromError.diagnostic?.nativeCause)
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
        assert(error.diagnostic?.nativePlatform == VCLError.Diagnostic.CodingKeys.ValueNativePlatformIos)
        assert(error.diagnostic?.nativeErrorType == "DummyError")
        assert(error.diagnostic?.nativeStackFrames?.isEmpty == false)
        assert(error.diagnostic?.nativeStackTop == error.diagnostic?.nativeStackFrames?.first)
        assert((error.diagnostic?.nativeStackFrames?.count ?? 0) <= VCLError.CodingKeys.MaxDiagnosticStackFrames)
    }

    func testErrorToJsonFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        let errorDictionary = error.toDictionary()

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == ErrorMocks.Payload)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyRequestId] as? String == ErrorMocks.RequestId)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyDiagnostic] as? [String: Any] == nil)
    }

    func testErrorToJsonFromProperties() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode : ErrorMocks.StatusCode,
            diagnostic: diagnostic
        )
        let errorDictionary = error.toDictionary()

        assert(errorDictionary[VCLError.CodingKeys.KeyPayload] as? String == nil)
        assert(errorDictionary[VCLError.CodingKeys.KeyError] as? String == ErrorMocks.Error)
        assert(errorDictionary[VCLError.CodingKeys.KeyErrorCode] as? String == ErrorMocks.ErrorCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyRequestId] as? String == ErrorMocks.RequestId)
        assert(errorDictionary[VCLError.CodingKeys.KeyMessage] as? String == ErrorMocks.Message)
        assert(errorDictionary[VCLError.CodingKeys.KeyStatusCode] as? Int == ErrorMocks.StatusCode)
        assert(errorDictionary[VCLError.CodingKeys.KeyDiagnostic] as? [String: Any] == nil)
    }

    func testErrorToDiagnosticJsonFromPayload() {
        let error = VCLError(payload: ErrorMocks.Payload)
        let errorDictionary = error.toDiagnosticDictionary()
        let diagnosticDictionary = errorDictionary[VCLError.CodingKeys.KeyDiagnostic] as? [String: Any]

        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativePlatform] as? String == VCLError.Diagnostic.CodingKeys.ValueNativePlatformIos)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeErrorType] as? String == VCLError.CodingKeys.ValuePayloadDiagnosticType)
        assert((diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeStackFrames] as? [String])?.count ?? 0 <= VCLError.CodingKeys.MaxDiagnosticStackFrames)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeStackTop] as? String != nil)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeCause] as? String == nil)
        assert(JSONSerialization.isValidJSONObject(errorDictionary))
    }

    func testErrorToDiagnosticJsonFromProperties() {
        let error = VCLError(
            error: ErrorMocks.Error,
            errorCode: ErrorMocks.ErrorCode,
            requestId: ErrorMocks.RequestId,
            message: ErrorMocks.Message,
            statusCode : ErrorMocks.StatusCode,
            diagnostic: diagnostic
        )
        let errorDictionary = error.toDiagnosticDictionary()
        let diagnosticDictionary = errorDictionary[VCLError.CodingKeys.KeyDiagnostic] as? [String: Any]

        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativePlatform] as? String == VCLError.Diagnostic.CodingKeys.ValueNativePlatformIos)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeErrorType] as? String == diagnostic.nativeErrorType)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeStackFrames] as? [String] == diagnostic.nativeStackFrames)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeStackTop] as? String == diagnostic.nativeStackTop)
        assert(diagnosticDictionary?[VCLError.Diagnostic.CodingKeys.KeyNativeCause] as? String == diagnostic.nativeCause)
        assert(JSONSerialization.isValidJSONObject(errorDictionary))
    }
}
