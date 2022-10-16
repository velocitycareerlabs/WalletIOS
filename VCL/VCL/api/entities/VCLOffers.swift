//
//  VCLOffers.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOffers {
    public let all: [[String: Any]]
    public let responseCode: Int
    public let token: VCLToken
    
    public init(all: [[String: Any]], responseCode: Int, token: VCLToken) {
        self.all = all
        self.responseCode = responseCode
        self.token = token
    }
}
