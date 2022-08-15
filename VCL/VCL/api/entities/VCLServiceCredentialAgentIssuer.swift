//
//  VCLServiceCredentialAgentIssuer.swift
//  VCL
//
//  Created by Michael Avoyan on 25/08/2021.
//

import Foundation

public class VCLServiceCredentialAgentIssuer: VCLService {
    
    public override init(payload: [String: Any]) {
        super.init(payload: payload)
    }
    
    public var credentialTypes: [String]? { get { payload[CodingKeys.KeyCredentialTypes] as? [String] } }
}
