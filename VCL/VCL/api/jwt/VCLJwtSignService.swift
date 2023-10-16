//
//  VCLJwtSignService.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol VCLJwtSignService {
    func sign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension VCLJwtSignService {
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        sign(
            kid: kid,
            nonce: nonce,
            jwtDescriptor: jwtDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: completionBlock
        )
    }
}