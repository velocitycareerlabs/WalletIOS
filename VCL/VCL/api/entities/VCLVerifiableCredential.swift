//
//  VCLVerifiableCredential.swift
//  
//
//  Created by Michael Avoyan on 26/04/2021.
//

import Foundation

public struct VCLVerifiableCredential {
    public let inputDescriptor: String
    public let jwtVc: String
    
    public init(inputDescriptor: String, jwtVc: String) {
        self.inputDescriptor = inputDescriptor
        self.jwtVc = jwtVc
    }
}
