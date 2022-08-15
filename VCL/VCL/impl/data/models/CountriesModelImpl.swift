//
//  CountriesModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//

import Foundation

class CountriesModelImpl: CountriesModel {

    private(set) var data: VCLCountries? = nil
    let countriesUseCase: CountriesUseCase
    
    init(_ countriesUseCase: CountriesUseCase) {
        self.countriesUseCase = countriesUseCase
    }
    
    func initialize(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void) {
        countriesUseCase.getCountries { [weak self] result in
                do {
                    self?.data = try result.get()
                } catch {}
            completionBlock(result)
        }
    }
}
