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
    case NotaryIssuer = "NotaryIssuer"
    case CareerIssuer = "CareerIssuer"
//    Identity issuer types:
    case IdentityIssuer = "IdentityIssuer"
    case IdDocumentIssuer = "IdDocumentIssuer"
    case NotaryIdDocumentIssuer = "NotaryIdDocumentIssuer"
    case ContactIssuer = "ContactIssuer"
    case NotaryContactIssuer = "NotaryContactIssuer"
    case Undefined = "Undefined"
    
    public static func fromString(value: String) -> VCLServiceType {
        if(value.contains(VCLServiceType.Inspector.rawValue)) {
            return .Inspector
        }
        if(value.contains(VCLServiceType.NotaryIssuer.rawValue)) {
            return .NotaryIssuer
        }
        if(value.contains(VCLServiceType.IdentityIssuer.rawValue)) {
            return .IdentityIssuer
        }
        if(value.contains(VCLServiceType.NotaryIdDocumentIssuer.rawValue)) {
            return .NotaryIdDocumentIssuer
        }
        if(value.contains(VCLServiceType.IdDocumentIssuer.rawValue)) {
            return .IdDocumentIssuer
        }
        if(value.contains(VCLServiceType.NotaryContactIssuer.rawValue)) {
            return .NotaryContactIssuer
        }
        if(value.contains(VCLServiceType.ContactIssuer.rawValue)) {
            return .ContactIssuer
        }
        if(value.contains(VCLServiceType.CareerIssuer.rawValue)) {
            return .CareerIssuer
        }
        if(value.contains(VCLServiceType.Issuer.rawValue)) {
            return .Issuer
        }
        return .Undefined
    }
}
