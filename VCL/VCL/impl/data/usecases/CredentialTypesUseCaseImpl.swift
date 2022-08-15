//
//  CredentialTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//

import Foundation

class CredentialTypesUseCaseImpl: CredentialTypesUseCase  {
    
    private let credentialTypesRepository: CredentialTypesRepository
    private let executor: Executor
    
    init(_ credentialTypesRepository: CredentialTypesRepository, _ executor: Executor) {
        self.credentialTypesRepository = credentialTypesRepository
        self.executor = executor
    }
    
    func getCredentialTypes(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.credentialTypesRepository.getCredentialTypes{ result in
                self?.executor.runOnMainThread {
                    completionBlock(result)
                }
            }
            
        }
    }
}
