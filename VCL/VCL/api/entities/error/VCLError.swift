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
        public let nativeCauseType: String?
        public let nativeCauseMessage: String?

        public init(
            nativePlatform: String = CodingKeys.ValueNativePlatformIos,
            nativeErrorType: String? = nil,
            nativeCauseType: String? = nil,
            nativeCauseMessage: String? = nil
        ) {
            self.nativePlatform = nativePlatform
            self.nativeErrorType = nativeErrorType
            self.nativeCauseType = nativeCauseType
            self.nativeCauseMessage = nativeCauseMessage
        }

        func toDictionary() -> [String: Any] {
            var dictionary: [String: Any] = [
                CodingKeys.KeyNativePlatform: nativePlatform
            ]

            if let nativeErrorType {
                dictionary[CodingKeys.KeyNativeErrorType] = nativeErrorType
            }
            if let nativeCauseType {
                dictionary[CodingKeys.KeyNativeCauseType] = nativeCauseType
            }
            if let nativeCauseMessage {
                dictionary[CodingKeys.KeyNativeCauseMessage] = nativeCauseMessage
            }

            return dictionary
        }

        public struct CodingKeys {
            public static let KeyNativePlatform = "nativePlatform"
            public static let KeyNativeErrorType = "nativeErrorType"
            public static let KeyNativeCauseType = "nativeCauseType"
            public static let KeyNativeCauseMessage = "nativeCauseMessage"
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
    fileprivate var wrapperStackFramesInternal: [String]?
    fileprivate var causeStackFramesInternal: [String]?

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
        self.wrapperStackFramesInternal = nil
        self.causeStackFramesInternal = nil
    }

    public init(
        payload: String?,
        errorCode: String? = nil
    ) {
        let payloadJson = payload?.toDictionary()
        self.init(
            payload: payload,
            error: payloadJson?[CodingKeys.KeyError] as? String,
            errorCode: (errorCode ?? payloadJson?[CodingKeys.KeyErrorCode] as? String) ?? VCLErrorCode.SdkError.rawValue,
            requestId: payloadJson?[CodingKeys.KeyRequestId] as? String,
            message: payloadJson?[CodingKeys.KeyMessage] as? String,
            statusCode: payloadJson?[CodingKeys.KeyStatusCode] as? Int,
            diagnostic: Self.captureDiagnostic(nativeErrorType: CodingKeys.ValuePayloadDiagnosticType)
        )
        self.wrapperStackFramesInternal = Thread.callStackSymbols
    }
    
    public init(
        error: Error? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        statusCode: Int? = nil
    ) {
        if let vclError = error as? VCLError {
            self.init(
                payload: vclError.payload,
                error: vclError.error,
                errorCode: vclError.errorCode,
                requestId: vclError.requestId,
                message: vclError.message,
                statusCode: vclError.statusCode ?? statusCode,
                diagnostic: vclError.diagnostic
            )
            self.wrapperStackFramesInternal = vclError.wrapperStackFramesInternal
            self.causeStackFramesInternal = vclError.causeStackFramesInternal
        } else {
            self.init(
                errorCode: errorCode,
                message: error.map { "\($0)" },
                statusCode: statusCode,
                diagnostic: error.map { Self.captureDiagnostic(from: $0) }
            )
            self.wrapperStackFramesInternal = error.map { _ in Thread.callStackSymbols }
            self.causeStackFramesInternal = Self.causeStackFrames(from: (error as NSError?)?.userInfo[NSUnderlyingErrorKey] as? Error)
        }
    }

    public func toDictionary() -> [String: Any?] {
        return [
            CodingKeys.KeyPayload: payload,
            CodingKeys.KeyError: error,
            CodingKeys.KeyErrorCode: errorCode,
            CodingKeys.KeyRequestId: requestId,
            CodingKeys.KeyMessage: message,
            CodingKeys.KeyStatusCode: statusCode
        ]
    }

    public func toDiagnosticDictionary() -> [String: Any] {
        var dictionary = toDictionary().compactMapValues { $0 }
        if let diagnostic {
            dictionary[CodingKeys.KeyDiagnostic] = diagnostic.toDictionary()
        }
        return dictionary
    }

    private static func captureDiagnostic(nativeErrorType: String) -> Diagnostic {
        return Diagnostic(nativeErrorType: nativeErrorType)
    }

    private static func captureDiagnostic(from error: Error) -> Diagnostic {
        let underlyingError = (error as NSError).userInfo[NSUnderlyingErrorKey] as? Error

        return Diagnostic(
            nativeErrorType: String(describing: type(of: error)),
            nativeCauseType: underlyingError.map { String(describing: type(of: $0)) },
            nativeCauseMessage: underlyingError.map { "\($0)" }
        )
    }

    private static func causeStackFrames(from error: Error?) -> [String]? {
        if let vclError = error as? VCLError {
            return vclError.wrapperStackFramesInternal
        }
        return nil
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
