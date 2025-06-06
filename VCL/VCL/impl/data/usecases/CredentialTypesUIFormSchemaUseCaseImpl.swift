//
//  CredentialTypesFormSchemaUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialTypesUIFormSchemaUseCaseImpl: CredentialTypesUIFormSchemaUseCase {
        
    private let credentialTypesUIFormSchemaRepository: CredentialTypesUIFormSchemaRepository
    private let executor: Executor
    private let dispatcher: Dispatcher
    
    init(_ credentialTypesUIFormSchemaRepository: CredentialTypesUIFormSchemaRepository,
         _ executor: Executor,
         _ dispatcher: Dispatcher) {
        self.credentialTypesUIFormSchemaRepository = credentialTypesUIFormSchemaRepository
        self.executor = executor
        self.dispatcher = dispatcher
    }
    
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        countries: VCLCountries,
        completionBlock: @escaping (VCLResult<VCLCredentialTypesUIFormSchema>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.credentialTypesUIFormSchemaRepository.getCredentialTypesUIFormSchema(
                credentialTypesUIFormSchemaDescriptor: credentialTypesUIFormSchemaDescriptor,
                countries: countries
            ) { [weak self] result in
                guard let _ = self else { return }
                self?.executor.runOnMain {
                    completionBlock(result)
                }
            }
        }
    }
}
