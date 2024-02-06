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
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func generateSignedJwt(
        didJwk: VCLDidJwk,
        nonce: String?, // nonce == challenge
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtServiceRepository {
    func generateSignedJwt(
        didJwk: VCLDidJwk,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        generateSignedJwt(
            didJwk: didJwk,
            nonce: nonce,
            jwtDescriptor: jwtDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            completionBlock: completionBlock
        )
    }
}
