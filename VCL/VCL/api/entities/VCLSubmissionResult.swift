//
//  VCLSubmissionResult.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLSubmissionResult {
    
    public let token: VCLToken
    public let exchange: VCLExchange
    public let jti: String
    public let submissionId: String
    
    public init(
        token: VCLToken,
        exchange: VCLExchange,
        jti: String,
        submissionId: String
    ) {
        self.token = token
        self.exchange = exchange
        self.jti = jti
        self.submissionId = submissionId
    }
    
    struct CodingKeys {
        static let KeyToken = "token"
        static let KeyExchange = "exchange"
        static let KeyJti = "jti"
        static let KeySubmissionId = "submissionId"
    }
}
