//
//  VCLServiceCredentialAgentIssuer.swift
//  VCL
//
//  Created by Michael Avoyan on 25/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLService: Sendable {
    public let payload: [String: Sendable]
    public var id: String { retrieveId() }
    public var type: String { retrieveType()  }
    public var serviceEndpoint: String { retrieveServiceEndpoint() }
    
    public init(payload: [String: Sendable]) {
        self.payload = payload
    }
    
    public var credentialTypes: [String]? { get { payload[CodingKeys.KeyCredentialTypes] as? [String] } }
    
    func retrieveId() -> String {
        return payload[CodingKeys.KeyId] as? String ?? ""
    }
    
    func retrieveType() -> String {
        return payload[CodingKeys.KeyType] as? String ?? ""
    }
    
    func retrieveServiceEndpoint() -> String {
        return payload[CodingKeys.KeyServiceEndpoint] as? String ?? ""
    }
    
    public func toPropsString() -> String {
        var propsString = "\npayload: \(payload)"
        propsString += "\nid: \(id)"
        propsString += "\ntype: \(type)"
        propsString += "\nserviceEndpoint: \(serviceEndpoint)"
        propsString += "\ncredentialTypes: \(String(describing: credentialTypes))"
        return propsString
    }
    
    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyType = "type"
        public static let KeyCredentialTypes = "credentialTypes"
        public static let KeyServiceEndpoint = "serviceEndpoint"
    }
}
