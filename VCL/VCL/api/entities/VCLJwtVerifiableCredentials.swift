//
//  VCLJwtVerifiableCredentials.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLJwtVerifiableCredentials {
    public let all: [VCLJwt]
    
    public init(all: [VCLJwt]) {
        self.all = all
    }
}
