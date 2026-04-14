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
    public let cause: Error?

    public init(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        requestId: String? = nil,
        message: String? = nil,
        statusCode: Int? = nil,
        cause: Error? = nil
    ) {
        self.payload = payload
        self.error = error
        self.errorCode = errorCode
        self.requestId = requestId
        self.message = message
        self.statusCode = statusCode
        self.cause = cause
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
            statusCode: payloadJson?[CodingKeys.KeyStatusCode] as? Int
        )
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
                cause: vclError.cause
            )
        } else {
            self.init(
                errorCode: errorCode,
                message: error.map { "\($0)" },
                statusCode: statusCode,
                cause: error
            )
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
    
    public struct CodingKeys {
        public static let KeyPayload = "payload"
        public static let KeyError = "error"
        public static let KeyErrorCode = "errorCode"
        public static let KeyRequestId = "requestId"
        public static let KeyMessage = "message"
        public static let KeyStatusCode = "statusCode"
    }
}
