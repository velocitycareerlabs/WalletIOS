//
//  VCLInjectedServicesDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLInjectedCryptoServicesDescriptor: Sendable {
    public let keyService: VCLKeyService
    public let jwtSignService: VCLJwtSignService
    public let jwtVerifyService: VCLJwtVerifyService?
    
    public init(
        keyService: VCLKeyService,
        jwtSignService: VCLJwtSignService,
        jwtVerifyService: VCLJwtVerifyService? = nil
        
    ) {
        self.keyService = keyService
        self.jwtSignService = jwtSignService
        self.jwtVerifyService = jwtVerifyService
    }
}
