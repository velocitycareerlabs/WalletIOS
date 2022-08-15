//
//  ExchangeProgressUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//

import Foundation

class ExchangeProgressUseCaseImpl: ExchangeProgressUseCase {
    private let exchangeProgressRepository: ExchangeProgressRepository
    private let executor: Executor
    
    init(_ exchangeProgressRepository: ExchangeProgressRepository, _ executor: Executor) {
        self.exchangeProgressRepository = exchangeProgressRepository
        self.executor = executor
    }
    
    func getExchangeProgress(exchangeDescriptor: VCLExchangeDescriptor,
                             completionBlock: @escaping (VCLResult<VCLExchange>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.exchangeProgressRepository.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) { submissionResult in
                self?.executor.runOnMainThread { completionBlock(submissionResult) }
            }
        }
    }
}
