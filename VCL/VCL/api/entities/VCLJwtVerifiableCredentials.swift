//
//  VCLJwtVerifiableCredentials.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//

import Foundation

public struct VCLJwtVerifiableCredentials {
    public let all: [VCLJWT]
    
    public init(all: [VCLJWT]) {
        self.all = all
    }
}
