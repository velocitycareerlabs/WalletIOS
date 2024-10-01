//
//  VCLCountry.swift
//  VCL
//
//  Created by Michael Avoyan on 13/02/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCountry: Sendable, VCLPlace {
    public let payload: [String: Sendable]
    public let code: String
    public let name: String
    public let regions: VCLRegions?
    
    public init(payload: [String: Sendable], code: String, name: String, regions: VCLRegions?) {
        self.payload = payload
        self.code = code
        self.name = name
        self.regions = regions
    }
    
    public enum Codes {
        public static let KeyCode = "code"
        public static let KeyName = "name"
        public static let KeyRegions = "regions"
    }
}
