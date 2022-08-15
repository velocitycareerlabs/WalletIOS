//
//  VCLCredentialTypeSchema.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

public struct VCLCredentialTypeSchema {
    public let payload: [String: Any]?
    
    public init(payload: [String: Any]?) {
        self.payload = payload
    }
}
