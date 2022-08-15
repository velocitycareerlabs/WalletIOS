//
//  VCLCredentialTypes.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//

public struct VCLCredentialTypes {
    public private(set) var all: [VCLCredentialType]? = nil
    public var recommendedTypes:[VCLCredentialType]? { get { all?.filter { $0.recommended == true } }}
    
    public init(all: [VCLCredentialType]?) {
        self.all = all
    }
}
