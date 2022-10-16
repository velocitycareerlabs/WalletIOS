//
//  VCLServiceType.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

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
