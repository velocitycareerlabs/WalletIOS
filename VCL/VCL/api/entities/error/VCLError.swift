//
//  VCLError.swift
//  VCL
//
//  Created by Michael Avoyan on 08/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLError: Error {
    public struct Diagnostic {
        public let nativePlatform: String
        public let nativeErrorType: String?
        public let nativeStackFrames: [String]?
        public let nativeStackTop: String?
        public let nativeCause: String?

        public init(
            nativePlatform: String = CodingKeys.ValueNativePlatformIos,
            nativeErrorType: String? = nil,
            nativeStackFrames: [String]? = nil,
            nativeStackTop: String? = nil,
            nativeCause: String? = nil
        ) {
            self.nativePlatform = nativePlatform
            self.nativeErrorType = nativeErrorType
            self.nativeStackFrames = nativeStackFrames
            self.nativeStackTop = nativeStackTop
            self.nativeCause = nativeCause
        }

        func toDictionary() -> [String: Any?] {
            return [
                CodingKeys.KeyNativePlatform: nativePlatform,
                CodingKeys.KeyNativeErrorType: nativeErrorType,
                CodingKeys.KeyNativeStackFrames: nativeStackFrames,
                CodingKeys.KeyNativeStackTop: nativeStackTop,
                CodingKeys.KeyNativeCause: nativeCause
            ]
        }

        public struct CodingKeys {
            public static let KeyNativePlatform = "nativePlatform"
            public static let KeyNativeErrorType = "nativeErrorType"
            public static let KeyNativeStackFrames = "nativeStackFrames"
            public static let KeyNativeStackTop = "nativeStackTop"
            public static let KeyNativeCause = "nativeCause"
            public static let ValueNativePlatformIos = "ios"
        }
    }

    public let payload: String?
    public let error: String?
    public let errorCode: String
    public let requestId: String?
    public let message: String?
    public let statusCode: Int?
    public let diagnostic: Diagnostic?

    public init(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        requestId: String? = nil,
        message: String? = nil,
        statusCode: Int? = nil,
        diagnostic: Diagnostic? = nil
    ) {
        self.payload = payload
        self.error = error
        self.errorCode = errorCode
        self.requestId = requestId
        self.message = message
        self.statusCode = statusCode
        self.diagnostic = diagnostic
    }

    public init(
        payload: String?,
        errorCode: String? = nil
    ) {
        let payloadJson = payload?.toDictionary()
        self.payload = payload
        self.error = payloadJson?[CodingKeys.KeyError] as? String
        self.errorCode = (errorCode ?? payloadJson?[CodingKeys.KeyErrorCode] as? String) ?? VCLErrorCode.SdkError.rawValue
        self.requestId = payloadJson?[CodingKeys.KeyRequestId] as? String
        self.message = payloadJson?[CodingKeys.KeyMessage] as? String
        self.statusCode = payloadJson?[CodingKeys.KeyStatusCode] as? Int
        self.diagnostic = Self.captureDiagnostic(nativeErrorType: CodingKeys.ValuePayloadDiagnosticType)
    }
    
    public init(
        error: Error? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        statusCode: Int? = nil
    ) {
        if let vclError = error as? VCLError {
            self.payload = vclError.payload
            self.error = vclError.error
            self.errorCode = vclError.errorCode
            self.requestId = vclError.requestId
            self.message = vclError.message
            self.statusCode = vclError.statusCode ?? statusCode
            self.diagnostic = vclError.diagnostic
        } else {
            self.payload = nil
            self.error = nil
            self.errorCode = errorCode
            self.requestId = nil
            self.message = error.map { "\($0)" }
            self.statusCode = statusCode
            self.diagnostic = error.map { Self.captureDiagnostic(from: $0) }
        }
    }

    public func toDictionary() -> [String: Any?] {
        return [
            CodingKeys.KeyPayload: payload,
            CodingKeys.KeyError: error,
            CodingKeys.KeyErrorCode: errorCode,
            CodingKeys.KeyRequestId: requestId,
            CodingKeys.KeyMessage: message,
            CodingKeys.KeyStatusCode: statusCode,
            CodingKeys.KeyDiagnostic: diagnostic?.toDictionary()
        ]
    }

    private static func captureDiagnostic(from error: Error) -> Diagnostic {
        return captureDiagnostic(
            nativeErrorType: String(describing: type(of: error)),
            nativeCause: ((error as NSError).userInfo[NSUnderlyingErrorKey]).map { "\($0)" }
        )
    }

    private static func captureDiagnostic(
        nativeErrorType: String,
        nativeCause: String? = nil
    ) -> Diagnostic {
        let nativeStackFrames = Thread.callStackSymbols

        return Diagnostic(
            nativeErrorType: nativeErrorType,
            nativeStackFrames: nativeStackFrames.isEmpty ? nil : nativeStackFrames,
            nativeStackTop: nativeStackFrames.first,
            nativeCause: nativeCause
        )
    }
    
    public struct CodingKeys {
        public static let KeyPayload = "payload"
        public static let KeyError = "error"
        public static let KeyErrorCode = "errorCode"
        public static let KeyRequestId = "requestId"
        public static let KeyMessage = "message"
        public static let KeyStatusCode = "statusCode"
        public static let KeyDiagnostic = "diagnostic"
        public static let ValuePayloadDiagnosticType = "VCLErrorPayload"
    }
}
