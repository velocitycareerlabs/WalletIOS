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
    case Issuer = "Issuer"
    case Inspector = "Inspector"
    case TrustRoot = "TrustRoot"
    case CareerIssuer = "CareerIssuer"
    case NodeOperator = "NodeOperator"
    case NotaryIssuer = "NotaryIssuer"
    case IdentityIssuer = "IdentityIssuer"
    case HolderAppProvider = "HolderAppProvider"
    case CredentialAgentOperator = "CredentialAgentOperator"
    case Undefined = "Undefined"

    public static func fromString(value: String) -> VCLServiceType {
        if(value.contains(VCLServiceType.NotaryIssuer.rawValue)) {
            return VCLServiceType.NotaryIssuer
        }
        if(value.contains(VCLServiceType.CareerIssuer.rawValue)) {
            return VCLServiceType.CareerIssuer
        }
        if(value.contains(VCLServiceType.IdentityIssuer.rawValue)) {
            return VCLServiceType.IdentityIssuer
        }
        if(value.contains(VCLServiceType.Issuer.rawValue)) {
            return VCLServiceType.Issuer
        }
        if(value.contains(VCLServiceType.Inspector.rawValue)) {
            return VCLServiceType.Inspector
        }
        if(value.contains(VCLServiceType.TrustRoot.rawValue)) {
            return VCLServiceType.TrustRoot
        }
        if(value.contains(VCLServiceType.NodeOperator.rawValue)) {
            return VCLServiceType.NodeOperator
        }
        if(value.contains(VCLServiceType.HolderAppProvider.rawValue)) {
            return VCLServiceType.HolderAppProvider
        }
        if(value.contains(VCLServiceType.CredentialAgentOperator.rawValue)) {
            return VCLServiceType.CredentialAgentOperator
        }
        return VCLServiceType.Undefined
    }
}
