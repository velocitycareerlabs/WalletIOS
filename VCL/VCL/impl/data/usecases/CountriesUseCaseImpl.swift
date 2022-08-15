//
//  CountriesUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//

import Foundation

class CountriesUseCaseImpl: CountriesUseCase  {
    
    private let countriesRepository: CountriesRepository
    private let executor: Executor
    
    init(_ countriesRepository: CountriesRepository, _ executor: Executor) {
        self.countriesRepository = countriesRepository
        self.executor = executor
    }
    
    func getCountries(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            self?.countriesRepository.getCountries { result in
                self?.executor.runOnMainThread {
                    completionBlock(result)
                }
            }
        }
    }
}
