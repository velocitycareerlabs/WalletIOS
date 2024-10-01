//
//  VCLExchange.swift
//  
//
//  Created by Michael Avoyan on 04/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLExchange: Sendable {
    public let id: String?
    public let type: String?
    public let disclosureComplete: Bool?
    public let exchangeComplete: Bool?
    
    public init(id: String? = nil, type: String? = nil, disclosureComplete: Bool? = nil, exchangeComplete: Bool? = nil) {
        self.id = id
        self.type = type
        self.disclosureComplete = disclosureComplete
        self.exchangeComplete = exchangeComplete
    }
    
    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyType = "type"
        public static let KeyDisclosureComplete = "disclosureComplete"
        public static let KeyExchangeComplete = "exchangeComplete"
    }
}

extension VCLExchange: Equatable {
}

public func == (lhs: VCLExchange, rhs: VCLExchange) -> Bool {
    return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.disclosureComplete == rhs.disclosureComplete &&
        lhs.exchangeComplete == rhs.exchangeComplete
}

public func != (lhs: VCLExchange, rhs: VCLExchange) -> Bool {
    return !(lhs == rhs)
}
