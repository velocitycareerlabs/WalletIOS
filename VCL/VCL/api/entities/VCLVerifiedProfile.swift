//
//  VCLVerifiedProfile.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//

import Foundation

public struct VCLVerifiedProfile {
    
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    
    public var credentialSubject: [String: Any]? { get { payload[CodingKeys.KeyCredentialSubject] as? [String : Any] } }
    
    public var name: String? { get { credentialSubject?[CodingKeys.KeyName] as? String } }
    public var logo: String? { get { credentialSubject?[CodingKeys.KeyLogo] as? String } }
    public var id: String? { get { credentialSubject?[CodingKeys.KeyId] as? String } }
    
    struct CodingKeys {
        static let KeyCredentialSubject = "credentialSubject"
        
        static let KeyName = "name"
        static let KeyLogo = "logo"
        static let KeyId = "id"
    }
}
