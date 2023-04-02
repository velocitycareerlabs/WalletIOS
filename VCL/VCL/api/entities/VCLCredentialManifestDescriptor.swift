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
    public let uri: String?
    public let issuingType: VCLIssuingType
    public let credentialTypes: [String]?
    public let pushDelegate: VCLPushDelegate?
    public let did: String?
    public let vendorOriginContext: String?
    
    public init(
        uri: String?,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil,
        vendorOriginContext: String? = nil
    ) {
        self.uri = uri
        self.issuingType = issuingType
        self.credentialTypes = credentialTypes
        self.pushDelegate = pushDelegate
        self.did = uri?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix)
        self.vendorOriginContext = vendorOriginContext
    }
    
    public var endpoint: String? { get { uri } }
    
    public struct CodingKeys {
        public static let KeyDidPrefix = "did:"
        public static let KeyCredentialTypes = "credential_types"
        public static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        public static let KeyPushDelegatePushToken = "push_delegate.push_token"
        
        public static let KeyCredentialId = "credentialId"
        public static let KeyRefresh = "refresh"
    }
}
