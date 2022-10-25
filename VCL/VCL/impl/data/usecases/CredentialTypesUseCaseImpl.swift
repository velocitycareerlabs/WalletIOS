//
//  CredentialTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialTypesUseCaseImpl: CredentialTypesUseCase  {
    
    private let credentialTypesRepository: CredentialTypesRepository
    private let executor: Executor
    
    init(_ credentialTypesRepository: CredentialTypesRepository, _ executor: Executor) {
        self.credentialTypesRepository = credentialTypesRepository
        self.executor = executor
    }
    
    func getCredentialTypes(
        resetCache: Bool,
        completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            self?.credentialTypesRepository.getCredentialTypes(resetCache: resetCache){ result in
                self?.executor.runOnMainThread {
                    completionBlock(result)
                }
            }
            
        }
    }
}
