//
//  VCLService.swift
//  VCL
//
//  Created by Michael Avoyan on 18/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLService {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    
    public var id: String { get { payload[CodingKeys.KeyId] as? String ?? "" } }
    public var type: String { get { payload[CodingKeys.KeyType] as? String ?? "" } }
    public var serviceEndpoint: String { get { payload[CodingKeys.KeyServiceEndpoint] as? String ?? "" } }
    
    open func toPropsString() -> String {
        var propsString = ""
        propsString += "\npayload: \(payload)"
        propsString += "\nid: \(id)"
        propsString += "\ntype: \(type)"
        propsString += "\nserviceEndpoint: \(serviceEndpoint)"
        return propsString
    }
    
    enum CodingKeys {
        static let KeyId = "id"
        static let KeyType = "type"
        static let KeyCredentialTypes = "credentialTypes"
        static let KeyServiceEndpoint = "serviceEndpoint"
    }
}
