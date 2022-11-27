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
    public let id: String
    
    public init(
        token: VCLToken,
        exchange: VCLExchange,
        id: String
    ) {
        self.token = token
        self.exchange = exchange
        self.id = id
    }
    
    struct CodingKeys {
        static let KeyToken = "token"
        static let KeyExchange = "exchange"
        static let KeyId = "id"
    }
}
