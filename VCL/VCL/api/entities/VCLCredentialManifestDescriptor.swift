//
//  VCLCredentialManifestDescriptor.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//

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
    
    struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyCredentialTypes = "credential_types"
        public static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        public static let KeyPushDelegatePushToken = "push_delegate.push_token"
        
        public static let KeyCredentialId = "credentialId"
        public static let KeyRefresh = "refresh"
    }
    
    public var endpoint: String { get { uri } }
}
