//
//  CredentialTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialTypesUseCaseImpl: CredentialTypesUseCase  {
        
    private let credentialTypesRepository: CredentialTypesRepository
    private let executor: Executor
    
    init(_ credentialTypesRepository: CredentialTypesRepository, _ executor: Executor) {
        self.credentialTypesRepository = credentialTypesRepository
        self.executor = executor
    }
    
    func getCredentialTypes(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.credentialTypesRepository.getCredentialTypes(cacheSequence: cacheSequence){ result in
                self?.executor.runOnMain {
                    completionBlock(result)
                }
            }
        }
    }
}
