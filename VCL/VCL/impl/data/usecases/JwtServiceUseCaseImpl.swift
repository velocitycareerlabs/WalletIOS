//
//  JwtServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class JwtServiceUseCaseImpl: JwtServiceUseCase {
    
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(_ jwtServiceRepository: JwtServiceRepository, _ executor: Executor) {
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func verifyJwt(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.jwtServiceRepository.verifyJwt(jwt: jwt, publicKey: publicKey) { isVeriviedResult in
                self?.executor.runOnMainThread { completionBlock(isVeriviedResult) }
            }
        }
    }
    
    func generateSignedJwt(payload: [String: Any], iss: String, jti: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(payload: payload, iss: iss, jti: jti) { isVeriviedResult in
                self?.executor.runOnMainThread { completionBlock(isVeriviedResult) }
            }
        }
    }
}
