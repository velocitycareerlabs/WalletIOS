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
    
    public let jwtSignService: VCLJwtSignService
    public let jwtVerifyService: VCLJwtVerifyService
    
    init(
        _ jwtSignService: VCLJwtSignService,
        _ jwtVerifyService: VCLJwtVerifyService
    ) {
        self.jwtSignService = jwtSignService
        self.jwtVerifyService = jwtVerifyService
    }
    
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        jwtVerifyService.verify(
            jwt: jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: { verificationResult in completionBlock(verificationResult) }
        )
    }
    
    func generateSignedJwt(
        didJwk: VCLDidJwk,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        jwtSignService.sign(
            didJwk: didJwk,
            nonce: nonce,
            jwtDescriptor: jwtDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: { jwtResult in completionBlock(jwtResult) }
        )
    }
}
