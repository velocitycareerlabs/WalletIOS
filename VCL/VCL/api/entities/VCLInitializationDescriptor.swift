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
    public let cacheSequence: Int
    public let keycahinAccessGroupIdentifier: String?
    
    public init(
        environment: VCLEnvironment = VCLEnvironment.PROD,
        cacheSequence: Int = 0,
        keycahinAccessGroupIdentifier: String? = nil
    ) {
        self.environment = environment
        self.cacheSequence = cacheSequence
        self.keycahinAccessGroupIdentifier = keycahinAccessGroupIdentifier
    }
}
