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
        public let nativeCauseStackTop: String?

        fileprivate let wrapperStackFramesInternal: [String]?
        fileprivate let causeStackFramesInternal: [String]?

        public init(
            nativePlatform: String = CodingKeys.ValueNativePlatformIos,
            nativeErrorType: String? = nil,
            nativeCauseType: String? = nil,
            nativeCauseMessage: String? = nil,
            nativeCauseStackTop: String? = nil
        ) {
            self.init(
                nativePlatform: nativePlatform,
                nativeErrorType: nativeErrorType,
                nativeCauseType: nativeCauseType,
                nativeCauseMessage: nativeCauseMessage,
                nativeCauseStackTop: nativeCauseStackTop,
                wrapperStackFramesInternal: nil,
                causeStackFramesInternal: nil
            )
        }

        fileprivate init(
            nativePlatform: String = CodingKeys.ValueNativePlatformIos,
            nativeErrorType: String? = nil,
            nativeCauseType: String? = nil,
            nativeCauseMessage: String? = nil,
            nativeCauseStackTop: String? = nil,
            wrapperStackFramesInternal: [String]? = nil,
            causeStackFramesInternal: [String]? = nil
        ) {
            self.nativePlatform = nativePlatform
            self.nativeErrorType = nativeErrorType
            self.nativeCauseType = nativeCauseType
            self.nativeCauseMessage = nativeCauseMessage
            self.nativeCauseStackTop = nativeCauseStackTop
            self.wrapperStackFramesInternal = wrapperStackFramesInternal
            self.causeStackFramesInternal = causeStackFramesInternal
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
            if let nativeCauseStackTop {
                dictionary[CodingKeys.KeyNativeCauseStackTop] = nativeCauseStackTop
            }

            return dictionary
        }

        public struct CodingKeys {
            public static let KeyNativePlatform = "nativePlatform"
            public static let KeyNativeErrorType = "nativeErrorType"
            public static let KeyNativeCauseType = "nativeCauseType"
            public static let KeyNativeCauseMessage = "nativeCauseMessage"
            public static let KeyNativeCauseStackTop = "nativeCauseStackTop"
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

    private static func captureDiagnostic(from error: Error) -> Diagnostic {
        let underlyingError = (error as NSError).userInfo[NSUnderlyingErrorKey] as? Error

        return captureDiagnostic(
            nativeErrorType: String(describing: type(of: error)),
            wrapperStackFramesInternal: Thread.callStackSymbols,
            nativeCauseType: underlyingError.map { String(describing: type(of: $0)) },
            nativeCauseMessage: underlyingError.map { "\($0)" },
            causeStackFramesInternal: causeStackFrames(from: underlyingError)
        )
    }

    private static func captureDiagnostic(
        nativeErrorType: String,
        wrapperStackFramesInternal: [String] = Thread.callStackSymbols,
        nativeCauseType: String? = nil,
        nativeCauseMessage: String? = nil,
        causeStackFramesInternal: [String]? = nil
    ) -> Diagnostic {
        return Diagnostic(
            nativeErrorType: nativeErrorType,
            nativeCauseType: nativeCauseType,
            nativeCauseMessage: nativeCauseMessage,
            nativeCauseStackTop: causeStackFramesInternal?.first,
            wrapperStackFramesInternal: wrapperStackFramesInternal,
            causeStackFramesInternal: causeStackFramesInternal
        )
    }

    private static func causeStackFrames(from error: Error?) -> [String]? {
        if let vclError = error as? VCLError {
            return vclError.diagnostic?.wrapperStackFramesInternal
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
