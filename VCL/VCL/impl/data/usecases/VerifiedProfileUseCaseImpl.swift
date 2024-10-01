//
//  VerifiedProfileUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class VerifiedProfileUseCaseImpl: VerifiedProfileUseCase {
    
    private let verifiedProfileRepository: VerifiedProfileRepository
    private let executor: Executor
    
    init(
        _ verifiedProfileRepository: VerifiedProfileRepository,
        _ executor: Executor
    ) {
        self.verifiedProfileRepository = verifiedProfileRepository
        self.executor = executor
    }
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping @Sendable (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            guard let self = self else { return }
            self.verifiedProfileRepository.getVerifiedProfile(
                verifiedProfileDescriptor: verifiedProfileDescriptor
            ) { result in
                self.executor.runOnMain {
                    completionBlock(result)
                }
            }
        }
    }
}
