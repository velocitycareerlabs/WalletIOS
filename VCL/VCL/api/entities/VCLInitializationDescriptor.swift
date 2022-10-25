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
    public let resetCache: Bool
    
    public init(environment: VCLEnvironment = VCLEnvironment.PROD, resetCache: Bool = false) {
        self.environment = environment
        self.resetCache = resetCache
    }
}
