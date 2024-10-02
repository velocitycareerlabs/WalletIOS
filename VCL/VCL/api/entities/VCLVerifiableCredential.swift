//
//  VCLVerifiableCredential.swift
//  
//
//  Created by Michael Avoyan on 26/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLVerifiableCredential: Sendable {
    public let inputDescriptor: String
    public let jwtVc: String
    
    public init(inputDescriptor: String, jwtVc: String) {
        self.inputDescriptor = inputDescriptor
        self.jwtVc = jwtVc
    }
}
