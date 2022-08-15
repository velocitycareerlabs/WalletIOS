//
//  VerifiedProfileUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//

import Foundation

class VerifiedProfileUseCaseImpl: VerifiedProfileUseCase {
    private let verifiedProfileRepository: VerifiedProfileRepository
    private let executor: Executor
    
    init(_ verifiedProfileRepository: VerifiedProfileRepository,
         _ executor: Executor) {
        self.verifiedProfileRepository = verifiedProfileRepository
        self.executor = executor
    }
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            self?.verifiedProfileRepository.getVerifiedProfile(
                verifiedProfileDescriptor: verifiedProfileDescriptor
            ) { result in
                self?.executor.runOnMainThread {
                    completionBlock(result)
                }
            }
        }
    }
    
}
