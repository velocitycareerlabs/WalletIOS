//
//  CountriesRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CountriesRepository{
    func getCountries(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCountries>) -> Void
    )
}
