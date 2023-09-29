//
//  JwtServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class JwtServiceUseCaseImpl: JwtServiceUseCase {
    
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
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.jwtServiceRepository.verifyJwt(jwt: jwt, publicJwk: publicJwk) { isVeriviedResult in
                self?.executor.runOnMain { completionBlock(isVeriviedResult) }
            }
        }
    }
    
    func generateSignedJwt(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(
                kid: kid,
                nonce: nonce,
                jwtDescriptor: jwtDescriptor
            ) { jwtResult in
                self?.executor.runOnMain { completionBlock(jwtResult) }
            }
        }
    }
}
