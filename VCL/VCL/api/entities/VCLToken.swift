//
//  VCLToken.swift
//  VCL
//
//  Created by Michael Avoyan on 18/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLToken {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }
}

public func == (lhs: VCLToken, rhs: VCLToken) -> Bool {
    return lhs.value == rhs.value
}
