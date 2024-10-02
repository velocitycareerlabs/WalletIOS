//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 08/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class JwtServiceRepositoryImpl: JwtServiceRepository {
    
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
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    ) {
        jwtVerifyService.verify(
            jwt: jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: { verificationResult in completionBlock(verificationResult) }
        )
    }
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    ) {
        jwtSignService.sign(
            jwtDescriptor: jwtDescriptor,
            nonce: nonce,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: { jwtResult in completionBlock(jwtResult) }
        )
    }
}
