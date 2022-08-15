//
//  VCLOrganization.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//

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
    
    struct CodingKeys {
        static let KeyService = "service"
    }
}
