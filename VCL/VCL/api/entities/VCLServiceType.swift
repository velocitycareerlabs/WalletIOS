//
//  VCLServiceType.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//

import Foundation

public enum VCLServiceType: String {
    case Issuer = "Issuer"
    case Inspector = "Inspector"
    case CredentialAgentOperator = "CredentialAgentOperator"
    case NodeOperator = "NodeOperator"
    case TrustRoot = "TrustRoot"
    case NotaryIssuer = "NotaryIssuer"
    case IdentityIssuer = "IdentityIssuer"
    case HolderAppProvider = "HolderAppProvider"
}
