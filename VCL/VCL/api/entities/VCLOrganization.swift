//
//  VCLOrganization.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOrganization {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    
    public var serviceCredentialAgentIssuers: [VCLServiceCredentialAgentIssuer] { get { parseServiceCredentialAgentIssuers() } }

    private func parseServiceCredentialAgentIssuers() -> [VCLServiceCredentialAgentIssuer] {
        var retVal = [VCLServiceCredentialAgentIssuer]()
        if let serviceJsonArr = payload[CodingKeys.KeyService] as? [[String: Any]] {
            for i in 0..<serviceJsonArr.count {
                retVal.append(VCLServiceCredentialAgentIssuer(payload: serviceJsonArr[i]))
            }
        }
        return retVal
    }
    
    public struct CodingKeys {
        public static let KeyService = "service"
    }
}
