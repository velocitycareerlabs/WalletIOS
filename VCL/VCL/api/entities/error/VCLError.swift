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
    public let message: String?
    public let statusCode: Int?

    public init(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String = VCLErrorCode.SdkError.rawValue,
        message: String? = nil,
        statusCode: Int? = nil
    ) {
        self.payload = payload
        self.error = error
        self.errorCode = errorCode
        self.message = message
        self.statusCode = statusCode
    }

    public init(
        payload: String?,
        errorCode: String = VCLErrorCode.SdkError.rawValue
    ) {
        let payloadJson = payload?.toDictionary()
        self.payload = payload
        self.error = payloadJson?[CodingKeys.KeyError] as? String
        self.errorCode = payloadJson?[CodingKeys.KeyErrorCode] as? String ?? errorCode
        self.message = payloadJson?[CodingKeys.KeyMessage] as? String
        self.statusCode = payloadJson?[CodingKeys.KeyStatusCode] as? Int
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
            self.message = vclError.message
            self.statusCode = vclError.statusCode ?? statusCode
        } else {
            self.payload = nil
            self.error = nil
            self.errorCode = errorCode
            self.message = "\(String(describing: error))"
            self.statusCode = statusCode
        }
    }

    public func toDictionary() -> [String: Any?] {
        return [
            CodingKeys.KeyPayload: payload,
            CodingKeys.KeyError: error,
            CodingKeys.KeyErrorCode: errorCode,
            CodingKeys.KeyMessage: message,
            CodingKeys.KeyStatusCode: statusCode
        ]
    }
    
    public struct CodingKeys {
        public static let KeyPayload = "payload"
        public static let KeyError = "error"
        public static let KeyErrorCode = "errorCode"
        public static let KeyMessage = "message"
        public static let KeyStatusCode = "statusCode"
    }
}
