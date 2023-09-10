//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 08/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class JwtServiceRepositoryImpl: JwtServiceRepository {
    
    private let jwtService: VCLJwtService
    
    init(_ jwtService: VCLJwtService) {
        self.jwtService = jwtService
    }
    
    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        jwtService.verify(
            jwt: jwt,
            jwkPublic: jwkPublic,
            completionBlock: { verificationResult in completionBlock(verificationResult) }
        )
    }
    
    func generateSignedJwt(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        jwtService.sign(
            kid: kid,
            nonce: nonce,
            jwtDescriptor: jwtDescriptor,
            completionBlock: { jwtResult in completionBlock(jwtResult) }
        )
    }
}
