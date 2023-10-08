//
//  VCLOffers.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOffers {
    public let payload: [String: Any]
    public let all: [[String: Any]]
    public let responseCode: Int
    public let issuingToken: VCLToken
    public let challenge: String
    
    public init(
        payload: [String: Any],
        all: [[String: Any]],
        responseCode: Int,
        token: VCLToken,
        challenge: String
    ) {
        self.payload = payload
        self.all = all
        self.responseCode = responseCode
        self.issuingToken = token
        self.challenge = challenge
    }
    
    public struct CodingKeys {
        public static let KeyOffers = "offers"
        public static let KeyChallenge = "challenge"
    }
}
