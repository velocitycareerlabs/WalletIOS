//
//  JwtServiceUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceUseCase {
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String?,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtServiceUseCase {
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
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
