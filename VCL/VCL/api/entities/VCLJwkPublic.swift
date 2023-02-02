//
//  VCLPublicKey.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLJwkPublic {
    public let valueStr: String
    public let valueDict: [String: Any]

    public init(valueStr: String) {
        self.valueStr = valueStr
        self.valueDict = valueStr.toDictionary() ?? [String: Any]()
    }
    public init(valueDict: [String: Any]) {
        self.valueStr = valueDict.toJsonString() ?? ""
        self.valueDict = valueDict
    }
    
    enum Format: String {
        case jwk = "jwk"
        case hex = "hex"
        case pem = "pem"
        case base58 = "base58"
    }
}
