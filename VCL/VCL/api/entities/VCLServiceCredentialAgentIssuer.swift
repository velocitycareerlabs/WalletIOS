//
//  VCLServiceCredentialAgentIssuer.swift
//  VCL
//
//  Created by Michael Avoyan on 25/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLServiceCredentialAgentIssuer: VCLService {
    
    public override init(payload: [String: Any]) {
        super.init(payload: payload)
    }
    
    public var credentialTypes: [String]? { get { payload[CodingKeys.KeyCredentialTypes] as? [String] } }
    
    public override func toPropsString() -> String {
        var propsString = super.toPropsString()
        propsString += "\ncredentialTypes: \(String(describing: credentialTypes))"
        return propsString
    }
}
