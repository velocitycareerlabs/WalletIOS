//
//  VCLDidJwkDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 02/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLDidJwkDescriptor{
    public let kid: String
    
    public init(kid: String) {
        self.kid = kid
    }
}
