//
//  CredentialTypesFormSchemaUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CredentialTypesUIFormSchemaUseCaseImpl: CredentialTypesUIFormSchemaUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
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
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(CredentialTypesUIFormSchemaUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.credentialTypesUIFormSchemaRepository.getCredentialTypesUIFormSchema(
                    credentialTypesUIFormSchemaDescriptor: credentialTypesUIFormSchemaDescriptor,
                    countries: countries) {
                        result in
                        _self.executor.runOnMainThread {
                            completionBlock(result)
                        }
                    }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
}
