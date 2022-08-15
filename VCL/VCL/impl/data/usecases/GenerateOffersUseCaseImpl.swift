//
//  GenerateOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//

import Foundation

class GenerateOffersUseCaseImpl: GenerateOffersUseCase {
    
    private let generateOffersRepository: GenerateOffersRepository
    private let executor: Executor
    
    init(_ generateOffersRepository: GenerateOffersRepository, _ executor: Executor) {
        self.generateOffersRepository = generateOffersRepository
        self.executor = executor
    }
    
    func generateOffers(token: VCLToken,
                        generateOffersDescriptor: VCLGenerateOffersDescriptor,
                        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.generateOffersRepository.generateOffers(
                token:token,
                generateOffersDescriptor: generateOffersDescriptor) { offersResult in
                self?.executor.runOnMainThread { completionBlock(offersResult) }
            }
        }
    }
}
