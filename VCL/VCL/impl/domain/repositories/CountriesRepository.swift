//
//  CountriesRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//

import Foundation

protocol CountriesRepository{
    func getCountries(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void)
}
