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
    
    public let exchangeToken: VCLToken
    public let exchange: VCLExchange
    public let jti: String
    public let submissionId: String
    
    public init(
        exchangeToken: VCLToken,
        exchange: VCLExchange,
        jti: String,
        submissionId: String
    ) {
        self.exchangeToken = exchangeToken
        self.exchange = exchange
        self.jti = jti
        self.submissionId = submissionId
    }
    
    public struct CodingKeys {
        public static let KeyToken = "token"
        public static let KeyExchange = "exchange"
        public static let KeyJti = "jti"
        public static let KeySubmissionId = "submissionId"
    }
}
