//
//  VCLServiceTypeDynamic.swift
//  VCL
//
//  Created by Michael Avoyan on 26/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLServiceTypeDynamic {
    public let payload: [String: Any]
    
    public init(payload: [String : Any]) {
        self.payload = payload
    }
    
    public var serviceType: String { get { payload[CodingKeys.KeyServiceType] as? String ?? "" } }
    public var serviceCategory: String { get { payload[CodingKeys.KeyServiceCategory] as? String ?? "" } }
    public var notary: Bool { get { payload[CodingKeys.KeyNotary] as? Bool ?? false } }
    public var credentialGroup: String { get { payload[CodingKeys.KeyCredentialGroup] as? String ?? "" } }
    
    public struct CodingKeys {
        public static let KeyServiceType = "serviceType"
        public static let KeyServiceCategory = "serviceCategory"
        public static let KeyNotary = "notary"
        public static let KeyCredentialGroup = "credentialGroup"
    }
}
