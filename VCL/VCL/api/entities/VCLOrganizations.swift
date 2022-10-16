//
//  VCLOrganizations.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

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
