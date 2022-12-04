//
//  CountriesModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CountriesModelImpl: CountriesModel {

    private(set) var data: VCLCountries? = nil
    let countriesUseCase: CountriesUseCase
    
    init(_ countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
    }
    
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCountries>) -> Void
    ) {
        countriesUseCase.getCountries(cacheSequence: cacheSequence) { [weak self] result in
                do {
                    self?.data = try result.get()
                } catch {}
            completionBlock(result)
        }
    }
}
