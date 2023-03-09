//
//  ExchangeProgressUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class ExchangeProgressUseCaseImpl: ExchangeProgressUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let exchangeProgressRepository: ExchangeProgressRepository
    private let executor: Executor
    
    init(_ exchangeProgressRepository: ExchangeProgressRepository, _ executor: Executor) {
        self.exchangeProgressRepository = exchangeProgressRepository
        self.executor = executor
    }
    
    func getExchangeProgress(exchangeDescriptor: VCLExchangeDescriptor,
                             completionBlock: @escaping (VCLResult<VCLExchange>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(ExchangeProgressUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.exchangeProgressRepository.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) { submissionResult in
                    _self.executor.runOnMainThread { completionBlock(submissionResult) }
                }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(description: "self is nil")))
            }
        }
    }
}
