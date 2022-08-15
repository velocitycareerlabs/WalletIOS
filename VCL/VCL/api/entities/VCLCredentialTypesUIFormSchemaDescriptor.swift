//
//  VCLCredentialTypesUIFormSchemaDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 10/08/2021.
//

import Foundation

public struct VCLCredentialTypesUIFormSchemaDescriptor {
    
    public let credentialType: String
    public let countryCode: String
    
    public init(credentialType: String, countryCode: String) {
        self.credentialType = credentialType
        self.countryCode = countryCode
    }
}
