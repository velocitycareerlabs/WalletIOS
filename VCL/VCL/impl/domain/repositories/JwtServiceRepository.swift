//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 07/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceRepository: Sendable {
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    )
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String?, // nonce == challenge
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtServiceRepository {
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    ) {
        generateSignedJwt(
            jwtDescriptor: jwtDescriptor,
            nonce: nonce,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: completionBlock
        )
    }
}
