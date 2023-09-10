//
//  VCLInjectedServicesDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLInjectedCryptoServicesDescriptor {
    public let keyService: VCLKeyService
    public let jwtService: VCLJwtService
    
    public init(keyService: VCLKeyService, jwtService: VCLJwtService) {
        self.keyService = keyService
        self.jwtService = jwtService
    }
}
