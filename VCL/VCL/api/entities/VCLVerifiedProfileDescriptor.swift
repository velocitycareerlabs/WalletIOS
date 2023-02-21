//
//  VCLVerifiedProfileDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLVerifiedProfileDescriptor {
    
    public let did: String
    
    public init(did: String) {
        self.did = did
    }
}
