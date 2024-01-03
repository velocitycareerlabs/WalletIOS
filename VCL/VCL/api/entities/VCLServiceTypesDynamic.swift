//
//  VCLServiceTypesDynamic.swift
//  VCL
//
//  Created by Michael Avoyan on 26/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLServiceTypesDynamic {
    public let all: [VCLServiceTypeDynamic]
    
    public init(all: [VCLServiceTypeDynamic]) {
        self.all = all
    }
    
    public struct CodingKeys {
        public static let KeyServiceTypes = "serviceTypes"
    }
}
