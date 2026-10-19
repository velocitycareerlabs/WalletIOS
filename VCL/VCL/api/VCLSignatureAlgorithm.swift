//
//  VCLSignatureAlgorithm.swift
//  VCL
//
//  Created by Michael Avoyan on 13/02/2024.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLSignatureAlgorithm: String {
    case ES256 = "P-256"
    case SECP256k1 = "secp256k1"
    
    /// The JWS `alg` header value for this algorithm's curve.
    public var jwsAlgorithm: String { get {
        switch self {
        case .ES256:
            return "ES256"
        case .SECP256k1:
            return "ES256K"
        }
    } }
    
    public var curve: String { get {
        self.rawValue
    } }
    
    /// Accepts a JWS algorithm (`ES256`, `ES256K`) or a JWK curve (`P-256`, `secp256k1`).
    /// Defaults to `.ES256` for empty or unknown values.
    public static func fromString(value: String) -> VCLSignatureAlgorithm {
        switch(value) {
        case VCLSignatureAlgorithm.ES256.jwsAlgorithm, VCLSignatureAlgorithm.ES256.curve:
            return .ES256
        case VCLSignatureAlgorithm.SECP256k1.jwsAlgorithm, VCLSignatureAlgorithm.SECP256k1.curve:
            return .SECP256k1
        default:
            return .ES256
        }
    }
}
