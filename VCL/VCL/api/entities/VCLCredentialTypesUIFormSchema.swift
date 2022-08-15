//
//  VCLCredentialTypesFormSchema.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//

import Foundation

public struct VCLCredentialTypesUIFormSchema {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    
    struct CodingKeys {
        static let KeyAddressRegion = "addressRegion"
        static let KeyAddressCountry = "addressCountry"
        static let KeyUiEnum = "ui:enum"
        static let KeyUiNames = "ui:enumNames"
    }
}
