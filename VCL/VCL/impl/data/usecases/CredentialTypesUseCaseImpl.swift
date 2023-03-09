//
//  CredentialTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CredentialTypesUseCaseImpl: CredentialTypesUseCase  {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
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
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(CredentialTypesUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.credentialTypesRepository.getCredentialTypes(cacheSequence: cacheSequence){ result in
                    _self.executor.runOnMainThread {
                        completionBlock(result)
                    }
                }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(description: "self is nil")))
            }
        }
    }
}
