//
//  JwtService.swift
//  
//
//  Created by Michael Avoyan on 28/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtService {
    func decode(
        encodedJwt: String,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
    func encode(
        jwt: String,
        completionBlock: @escaping (VCLResult<String>) -> Void
    )
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )

    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
}
