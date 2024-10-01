//
//  VCLKeyServiceType.swift
//  VCL
//
//  Created by Michael Avoyan on 08/06/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLCryptoServiceType: String, Sendable {
    case Local = "local"
    case Remote = "remote"
    case Injected = "injected"
    
    public static func fromString(value: String) -> VCLCryptoServiceType {
        switch(value) {
        case VCLCryptoServiceType.Local.rawValue:
            return .Local
        case VCLCryptoServiceType.Remote.rawValue:
            return .Remote
        case VCLCryptoServiceType.Injected.rawValue:
            return .Injected
        default:
            return .Local
        }
    }
}
