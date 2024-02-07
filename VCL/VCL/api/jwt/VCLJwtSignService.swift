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
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String?,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension VCLJwtSignService {
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        sign(
            jwtDescriptor: jwtDescriptor,
            nonce: nonce,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: completionBlock
        )
    }
}
