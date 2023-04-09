//
//  GenerateOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class GenerateOffersUseCaseImpl: GenerateOffersUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let generateOffersRepository: GenerateOffersRepository
    private let executor: Executor
    
    init(_ generateOffersRepository: GenerateOffersRepository, _ executor: Executor) {
        self.generateOffersRepository = generateOffersRepository
        self.executor = executor
    }
    
    func generateOffers(
        token: VCLToken,
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(GenerateOffersUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.generateOffersRepository.generateOffers(
                    token:token,
                    generateOffersDescriptor: generateOffersDescriptor) { offersResult in
                        _self.executor.runOnMainThread { completionBlock(offersResult) }
                    }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
}
