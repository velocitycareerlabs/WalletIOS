//
//  GenerateOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class GenerateOffersUseCaseImpl: GenerateOffersUseCase {
    
    private let generateOffersRepository: GenerateOffersRepository
    private let executor: Executor
    
    init(_ generateOffersRepository: GenerateOffersRepository, _ executor: Executor) {
        self.generateOffersRepository = generateOffersRepository
        self.executor = executor
    }
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        issuingToken: VCLToken,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.generateOffersRepository.generateOffers(
                generateOffersDescriptor: generateOffersDescriptor,
                issuingToken: issuingToken
            ) { offersResult in
                    self?.executor.runOnMain { completionBlock(offersResult) }
                }
        }
    }
}
