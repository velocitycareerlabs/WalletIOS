//
//  KeyServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class KeyServiceUseCaseImpl: KeyServiceUseCase {
    
    private let keyServiceRepository: KeyServiceRepository
    private let executor: Executor
    
    init(
        _ keyServiceRepository: KeyServiceRepository,
        _ executor: Executor
    ) {
        self.keyServiceRepository = keyServiceRepository
        self.executor = executor
    }
    
    func generateDidJwk(
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.keyServiceRepository.generateDidJwk(
                remoteCryptoServicesToken: remoteCryptoServicesToken
            ) { didJwkResult in
                self?.executor.runOnMain { completionBlock(didJwkResult) }
            }
        }
    }
}
