//
//  VCLKeyServiceUrls.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLKeyServiceUrls: Sendable {
    public let createDidKeyServiceUrl: String
    
    public init(createDidKeyServiceUrl: String) {
        self.createDidKeyServiceUrl = createDidKeyServiceUrl
    }
}
