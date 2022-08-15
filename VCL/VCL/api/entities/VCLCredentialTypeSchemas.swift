//
//  VCLCredentialTypeSchemas.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

public struct VCLCredentialTypeSchemas {
    public private(set) var all: [String: VCLCredentialTypeSchema]? = nil
    
    public init(all: [String: VCLCredentialTypeSchema]?) {
        self.all = all
    }
}
