//
//  VCLCredentialTypes.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public struct VCLCredentialTypes: Sendable {
    public private(set) var all: [VCLCredentialType]? = nil
    public var recommendedTypes:[VCLCredentialType]? { get { all?.filter { $0.recommended == true } }}
    
    public init(all: [VCLCredentialType]?) {
        self.all = all
    }
    
    public func credentialTypeByTypeName(type: String) -> VCLCredentialType? {
        return all?.first { type == $0.credentialType }
    }
}
