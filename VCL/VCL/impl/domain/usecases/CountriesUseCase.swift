//
//  CountriesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//

import Foundation

protocol CountriesUseCase {
    func getCountries(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void)
}
