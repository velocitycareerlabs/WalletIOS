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
//    "ES256K" // The only algorithm supported locally
    
    public var jwsAlgorithm: String { get {
        return "ES256K" // The only algorithm supported locally
    } }
    
    public var curve: String { get {
        self.rawValue
    } }
    
    public static func fromString(value: String) -> VCLSignatureAlgorithm {
        switch(value) {
        case VCLSignatureAlgorithm.ES256.rawValue:
            return .ES256
        case VCLSignatureAlgorithm.SECP256k1.rawValue:
            return .SECP256k1
        default:
            return .ES256
        }
    }
}
