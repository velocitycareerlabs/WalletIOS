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
    
    public init(token: VCLToken, exchange: VCLExchange) {
        self.token = token
        self.exchange = exchange
    }
    
    struct CodingKeys {
        static let KeyToken = "token"
        static let KeyExchange = "exchange"
    }
}

extension VCLSubmissionResult: Equatable {
}

public func == (lhs: VCLSubmissionResult, rhs: VCLSubmissionResult) -> Bool {
    return lhs.token == rhs.token && lhs.exchange == rhs.exchange
}

public func != (lhs: VCLSubmissionResult, rhs: VCLSubmissionResult) -> Bool {
    return !(lhs == rhs)
}
