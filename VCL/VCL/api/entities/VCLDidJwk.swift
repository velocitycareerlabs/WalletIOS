//
//  VCLDidJwk.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLDidJwk {
    public let value: String
    
    public static let DidJwkPrefix = "did:jwk:"
    
    public init(value: String) {
        self.value = value
    }
}
