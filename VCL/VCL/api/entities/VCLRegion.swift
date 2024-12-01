//
//  VCLRegion.swift
//  VCL
//
//  Created by Michael Avoyan on 16/02/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLRegion: VCLPlace {
    public let payload: [String: Any]
    public let code: String
    public let name: String

    public init(payload: [String: Any], code: String, name: String) {
        self.payload = payload
        self.code = code
        self.name = name
    }
    
    public enum Codes {
        public static let  KeyCode = "code"
        public static let  KeyName = "name"
    }
}
