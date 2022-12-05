//
//  VCLCredentialManifestDescriptor.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptor {
    public let uri: String
    public let credentialTypes: [String]?
    public let pushDelegate: VCLPushDelegate?
    
    public init(uri: String,
                credentialTypes: [String]? = nil,
                pushDelegate: VCLPushDelegate? = nil) {
        self.uri = uri
        self.credentialTypes = credentialTypes
        self.pushDelegate = pushDelegate
    }
    
    public struct CodingKeys {
        static let KeyId = "id"
        static let KeyCredentialTypes = "credential_types"
        static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        static let KeyPushDelegatePushToken = "push_delegate.push_token"
        
        static let KeyCredentialId = "credentialId"
        static let KeyRefresh = "refresh"
    }
    
    public var endpoint: String { get { uri } }
}
