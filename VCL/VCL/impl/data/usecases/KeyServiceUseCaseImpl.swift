//
//  KeyServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class KeyServiceUseCaseImpl: KeyServiceUseCase {
    
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
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            guard let self = self else { return }
            self.keyServiceRepository.generateDidJwk(
                didJwkDescriptor: didJwkDescriptor
            ) { didJwkResult in
                self.executor.runOnMain { completionBlock(didJwkResult) }
            }
        }
    }
}
