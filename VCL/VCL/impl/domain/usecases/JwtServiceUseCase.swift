//
//  JwtServiceUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceUseCase {
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
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
}
