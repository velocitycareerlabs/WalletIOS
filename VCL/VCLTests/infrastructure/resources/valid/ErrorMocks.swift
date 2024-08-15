//
//  ErrorMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 08/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class ErrorMocks {
    
    static let Payload = "{\"error\":\"Bad Request\",\"errorCode\": \"proof_jwt_is_required\",\"requestId\": \"some_request_id\",\"message\":\"proof.jwt is missing\",\"statusCode\": 400}"
    static let Error = "Bad Request"
    static let ErrorCode = "proof_jwt_is_required"
    static let RequestId = "some_request_id"
    static let Message = "proof.jwt is missing"
    static let StatusCode = 400
}
