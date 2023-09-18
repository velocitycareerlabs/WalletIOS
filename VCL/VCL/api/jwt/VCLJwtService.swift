//
//  VCLJwtService.swift
//  
//
//  Created by Michael Avoyan on 28/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol VCLJwtService {
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func sign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension VCLJwtService {
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        sign(kid: kid, nonce: nonce, jwtDescriptor: jwtDescriptor, completionBlock: completionBlock)
    }
}
