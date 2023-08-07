//
//  VCLInitializationDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 23/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLInitializationDescriptor {
    public let environment: VCLEnvironment
    public let keyServiceType: VCLKeyServiceType
    public let xVnfProtocolVersion: VCLXVnfProtocolVersion
    public let cacheSequence: Int
    public let keycahinAccessGroupIdentifier: String?
    public let isDebugOn: Bool
    
    public init(
        environment: VCLEnvironment = .Prod,
        keyServiceType: VCLKeyServiceType = .Local,
        xVnfProtocolVersion: VCLXVnfProtocolVersion = .XVnfProtocolVersion1,
        cacheSequence: Int = 0,
        keycahinAccessGroupIdentifier: String? = nil,
        isDebugOn: Bool = false
    ) {
        self.environment = environment
        self.keyServiceType = keyServiceType
        self.xVnfProtocolVersion = xVnfProtocolVersion
        self.cacheSequence = cacheSequence
        self.keycahinAccessGroupIdentifier = keycahinAccessGroupIdentifier
        self.isDebugOn = isDebugOn
    }
}
