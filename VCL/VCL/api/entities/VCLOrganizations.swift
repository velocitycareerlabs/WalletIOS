//
//  VCLOrganizations.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//

import Foundation

public struct VCLOrganizations {
    public let all: [VCLOrganization]
    
    public init(all: [VCLOrganization]) {
        self.all = all
    }
    
    struct CodingKeys {
        static let KeyResult = "result"
    }
}
