//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 07/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceRepository {
    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func generateSignedJwt(
        kid: String?, // did:jwk in case of person binding
        nonce: String?, // nonce == challenge
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtServiceRepository {
    func generateSignedJwt(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        generateSignedJwt(kid: kid, nonce: nonce, jwtDescriptor: jwtDescriptor, completionBlock: completionBlock)
    }
}
