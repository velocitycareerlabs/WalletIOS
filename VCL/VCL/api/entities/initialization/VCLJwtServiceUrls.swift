//
//  VCLJwtServiceUrls.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLJwtServiceUrls {
    public let jwtSignServiceUrl: String
    public let jwtVerifyServiceUrl: String?
    
    public init(
        jwtSignServiceUrl: String,
        jwtVerifyServiceUrl: String? = nil
    ) {
        self.jwtSignServiceUrl = jwtSignServiceUrl
        self.jwtVerifyServiceUrl = jwtVerifyServiceUrl
    }
}
