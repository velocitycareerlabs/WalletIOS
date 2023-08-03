//
//  VCLServiceType.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLServiceType: String {
    case Inspector = "Inspector"
    case Issuer = "Issuer"
    case IdentityIssuer = "IdentityIssuer"
    case NotaryIssuer = "NotaryIssuer"
    case CareerIssuer = "CareerIssuer"
    case Undefined = "Undefined"
    
    public static func fromString(value: String) -> VCLServiceType {
        if(value.contains(VCLServiceType.Inspector.rawValue)) {
            return VCLServiceType.Inspector
        }
        if(value.contains(VCLServiceType.NotaryIssuer.rawValue)) {
            return VCLServiceType.NotaryIssuer
        }
        if(value.contains(VCLServiceType.IdentityIssuer.rawValue)) {
            return VCLServiceType.IdentityIssuer
        }
        if(value.contains(VCLServiceType.CareerIssuer.rawValue)) {
            return VCLServiceType.CareerIssuer
        }
        if(value.contains(VCLServiceType.Issuer.rawValue)) {
            return VCLServiceType.Issuer
        }
        return VCLServiceType.Undefined
    }
}
