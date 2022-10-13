//
//  VCLPublicKey.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPublicKey {
    public let jwkStr: String
    public let jwkDict: [String: Any]
    
    public init(jwkDict: [String: Any]) {
        self.jwkDict = jwkDict
        self.jwkStr = self.jwkDict.toJsonString() ?? ""
    }

    public init(jwkStr: String) {
        self.jwkStr = jwkStr
        self.jwkDict = self.jwkStr.toDictionary() ?? [String: Any]()
    }
    
    enum Format: String {
        case jwk = "jwk"
        case hex = "hex"
        case pem = "pem"
        case base58 = "base58"
    }
}

extension VCLPublicKey: Equatable {
}

public func == (lhs: VCLPublicKey, rhs: VCLPublicKey) -> Bool {
    return lhs.jwkDict == rhs.jwkDict
}

public func != (lhs: VCLPublicKey, rhs: VCLPublicKey) -> Bool {
    return !(lhs == rhs)
}
