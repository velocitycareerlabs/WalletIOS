//
//  AuthTokenUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class AuthTokenUseCaseImpl: AuthTokenUseCase {
    private let authTokenRepository: AuthTokenRepository
    private let executor: Executor

    init(
        _ authTokenRepository: AuthTokenRepository,
        _ executor: Executor
    ) {
        self.authTokenRepository = authTokenRepository
        self.executor = executor
    }

    func getAuthToken(
        authTokenDescriptor: VCLAuthTokenDescriptor,
        completionBlock: @escaping (VCLResult<VCLAuthToken>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.authTokenRepository.getAuthToken(authTokenDescriptor: authTokenDescriptor) { result in
                self?.executor.runOnMain {
                    completionBlock(result)
                }
            }
        }
    }
}
