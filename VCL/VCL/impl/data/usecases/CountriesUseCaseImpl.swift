//
//  CountriesUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CountriesUseCaseImpl: CountriesUseCase  {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let countriesRepository: CountriesRepository
    private let executor: Executor
    
    init(_ countriesRepository: CountriesRepository, _ executor: Executor) {
        self.countriesRepository = countriesRepository
        self.executor = executor
    }
    
    func getCountries(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCountries>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(CountriesUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.countriesRepository.getCountries(cacheSequence: cacheSequence) { result in
                    _self.executor.runOnMain {
                        completionBlock(result)
                    }
                }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
}
