//
//  VCLOffers.swift
//
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOffer: Sendable {
    public let payload: [String: Sendable]
    
    public init(payload: [String : Sendable]) {
        self.payload = payload
    }
    
    public var issuerId: String { get { (payload[CodingKeys.KeyIssuer] as? [String: Sendable])?[CodingKeys.KeyId] as? String
        ?? payload[CodingKeys.KeyIssuer] as? String
        ?? ""
    }}
    
    public var id: String { get{ payload[CodingKeys.KeyId] as? String ?? "" } }

    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyDid = "did"
        public static let KeyIssuer = "issuer"
    }
}
