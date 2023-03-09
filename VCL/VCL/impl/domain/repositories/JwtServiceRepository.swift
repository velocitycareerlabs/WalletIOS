//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 07/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceRepository {
    func decode(
        encodedJwt: String,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
    func generateDidJwk(
        jwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
}
