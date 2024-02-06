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
        didJwk: VCLDidJwk,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtServiceUseCase {
    func generateSignedJwt(
        didJwk: VCLDidJwk,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
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
