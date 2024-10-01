//
//  VCLToken.swift
//  VCL
//
//  Created by Michael Avoyan on 18/07/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLToken: Sendable {
    /// token value represented as jwt string
    public let value: String
    /// token value represented as VCLJwt object
    public let jwtValue: VCLJwt
    
    public init(value: String) {
        self.value = value
        self.jwtValue = VCLJwt(encodedJwt: value)
    }
    
    public init(jwtValue: VCLJwt) {
        self.value = jwtValue.encodedJwt
        self.jwtValue = jwtValue
    }
    
    /// token expiration period in milliseconds
    public var expiresIn: Double? { get { jwtValue.payload?[CodingKeys.KeyExp] as? Double } }
    
    public struct CodingKeys {
        public static let KeyExp = "exp"
    }
}

public func == (lhs: VCLToken, rhs: VCLToken) -> Bool {
    return lhs.value == rhs.value
}
