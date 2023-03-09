//
//  VCLError.swift
//  VCL
//
//  Created by Michael Avoyan on 08/03/2023.
//

import Foundation

public struct VCLError: Error {
    public let payload: String?
    public let error: String?
    public let errorCode: String?
    public let message: String?
    public let statusCode: Int?

    public init(
        payload: String? = nil,
        error: String? = nil,
        errorCode: String? = nil,
        message: String? = nil,
        statusCode: Int? = nil
    ) {
        self.payload = payload
        self.error = error
        self.errorCode = errorCode
        self.message = message
        self.statusCode = statusCode
    }

    public init(payload: String) {
        let payloadJson = payload.toDictionary()
        self.payload = payload
        self.error = payloadJson?[CodingKeys.KeyError] as? String
        self.errorCode = payloadJson?[CodingKeys.KeyErrorCode] as? String
        self.message = payloadJson?[CodingKeys.KeyMessage] as? String
        self.statusCode = payloadJson?[CodingKeys.KeyStatusCode] as? Int
    }
    
    public init(error: Error? = nil, code: Int? = nil) {
        self.payload = nil
        self.error = nil
        self.errorCode = nil
        self.message = "\(String(describing: error))"
        self.statusCode = code
    }

    public func toDictionary() -> [String: Any?] {
        return [
            CodingKeys.KeyPayload: payload,
            CodingKeys.KeyError: error,
            CodingKeys.KeyErrorCode: errorCode,
            CodingKeys.KeyMessage: message,
            CodingKeys.KeyErrorCode: errorCode
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
