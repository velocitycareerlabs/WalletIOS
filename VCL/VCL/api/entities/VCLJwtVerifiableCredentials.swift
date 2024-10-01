//
//  VCLJwtVerifiableCredentials.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLJwtVerifiableCredentials: Sendable {
    public let passedCredentials: [VCLJwt]
    public let failedCredentials: [VCLJwt]
    
    public init(
        passedCredentials: [VCLJwt],
        failedCredentials: [VCLJwt]
    ) {
        self.passedCredentials = passedCredentials
        self.failedCredentials = failedCredentials
    }
}
