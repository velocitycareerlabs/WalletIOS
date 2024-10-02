//
//  JwtServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class JwtServiceUseCaseImpl: JwtServiceUseCase {
    
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(
        _ jwtServiceRepository: JwtServiceRepository,
        _ executor: Executor
    ) {
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            guard let self = self else { return }
            self.jwtServiceRepository.verifyJwt(
                jwt: jwt,
                publicJwk: publicJwk,
                remoteCryptoServicesToken: remoteCryptoServicesToken
            ) { isVeriviedResult in
                self.executor.runOnMain { completionBlock(isVeriviedResult) }
            }
        }
    }
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            guard let self = self else { return }
            self.jwtServiceRepository.generateSignedJwt(
                jwtDescriptor: jwtDescriptor,
                nonce: nonce,
                didJwk: didJwk,
                remoteCryptoServicesToken: remoteCryptoServicesToken
            ) { jwtResult in
                self.executor.runOnMain { completionBlock(jwtResult) }
            }
        }
    }
}
