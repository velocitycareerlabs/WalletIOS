//
//  CountriesModel.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//

import Foundation

protocol CountriesModel: Model {
    var data: VCLCountries? { get }
    func initialize(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void)
}
