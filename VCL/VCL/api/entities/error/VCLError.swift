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
    public let payload: String?
    public let error: String?
    public let errorCode: String
    public let requestId: String?
    public let message: String?
    public let statusCode: Int?
    public let sourceErrorCode: String?
    public let validationPhase: String?
    public let requestDid: String?
    public let requestUri: String?
    public let requestKind: String?
    public let cause: Error?
    internal let callStackSymbols: [String]?

    public init(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        requestId: String? = nil,
        message: String? = nil,
        statusCode: Int? = nil,
        sourceErrorCode: String? = nil,
        validationPhase: String? = nil,
        requestDid: String? = nil,
        requestUri: String? = nil,
        requestKind: String? = nil,
        cause: Error? = nil
    ) {
        self.payload = payload
        self.error = error
        self.errorCode = errorCode
        self.requestId = requestId
        self.message = message
        self.statusCode = statusCode
        self.sourceErrorCode = sourceErrorCode
        self.validationPhase = validationPhase
        self.requestDid = requestDid
        self.requestUri = requestUri
        self.requestKind = requestKind
        self.cause = cause
        self.callStackSymbols = Thread.callStackSymbols
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
        self.sourceErrorCode = nil
        self.validationPhase = nil
        self.requestDid = nil
        self.requestUri = nil
        self.requestKind = nil
        self.cause = nil
        self.callStackSymbols = Thread.callStackSymbols
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
            self.statusCode = statusCode ?? vclError.statusCode
            self.sourceErrorCode = vclError.sourceErrorCode
            self.validationPhase = vclError.validationPhase
            self.requestDid = vclError.requestDid
            self.requestUri = vclError.requestUri
            self.requestKind = vclError.requestKind
            self.cause = vclError.cause
            self.callStackSymbols = vclError.callStackSymbols
        } else {
            self.payload = nil
            self.error = nil
            self.errorCode = errorCode
            self.requestId = nil
            self.message = error.map { "\($0)" }
            self.statusCode = statusCode
            self.sourceErrorCode = nil
            self.validationPhase = nil
            self.requestDid = nil
            self.requestUri = nil
            self.requestKind = nil
            self.cause = error
            self.callStackSymbols = Thread.callStackSymbols
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
            CodingKeys.KeySourceErrorCode: sourceErrorCode,
            CodingKeys.KeyValidationPhase: validationPhase,
            CodingKeys.KeyRequestDid: requestDid,
            CodingKeys.KeyRequestUri: requestUri,
            CodingKeys.KeyRequestKind: requestKind,
            CodingKeys.KeyCallStackSymbols: callStackSymbols
        ]
    }
    
    func copy(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String? = nil,
        requestId: String? = nil,
        message: String? = nil,
        statusCode: Int? = nil,
        sourceErrorCode: String? = nil,
        validationPhase: String? = nil,
        requestDid: String? = nil,
        requestUri: String? = nil,
        requestKind: String? = nil,
        cause: Error? = nil
    ) -> VCLError {
        VCLError(
            payload: payload ?? self.payload,
            error: error ?? self.error,
            errorCode: errorCode ?? self.errorCode,
            requestId: requestId ?? self.requestId,
            message: message ?? self.message,
            statusCode: statusCode ?? self.statusCode,
            sourceErrorCode: sourceErrorCode ?? self.sourceErrorCode,
            validationPhase: validationPhase ?? self.validationPhase,
            requestDid: requestDid ?? self.requestDid,
            requestUri: requestUri ?? self.requestUri,
            requestKind: requestKind ?? self.requestKind,
            cause: cause ?? self.cause
        )
    }
    
    public struct CodingKeys {
        public static let KeyPayload = "payload"
        public static let KeyError = "error"
        public static let KeyErrorCode = "errorCode"
        public static let KeyRequestId = "requestId"
        public static let KeyMessage = "message"
        public static let KeyStatusCode = "statusCode"
        public static let KeySourceErrorCode = "sourceErrorCode"
        public static let KeyValidationPhase = "validationPhase"
        public static let KeyRequestDid = "requestDid"
        public static let KeyRequestUri = "requestUri"
        public static let KeyRequestKind = "requestKind"
        public static let KeyCallStackSymbols = "callStackSymbols"
    }
}
