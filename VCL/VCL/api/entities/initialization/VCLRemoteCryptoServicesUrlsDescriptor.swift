//
//  VCLRemoteServicesUrlsDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLRemoteCryptoServicesUrlsDescriptor: Sendable {
    public let keyServiceUrls: VCLKeyServiceUrls
    public let jwtServiceUrls: VCLJwtServiceUrls
    
    public init(
        keyServiceUrls: VCLKeyServiceUrls,
        jwtServiceUrls: VCLJwtServiceUrls
    ) {
        self.keyServiceUrls = keyServiceUrls
        self.jwtServiceUrls = jwtServiceUrls
    }
}
