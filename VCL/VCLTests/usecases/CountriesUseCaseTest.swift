//
//  CountriesUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 13/12/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CountriesUseCaseTest: XCTestCase {
    
    private var subject: CountriesUseCase!
    
    override func setUp() {
    }
    
    func testGetCountriesSuccess() {
        subject = CountriesUseCaseImpl(
            CountriesRepositoryImpl(
                NetworkServiceSuccess(
                    validResponse: CountriesMocks.CountriesJson
                ), EmptyCacheService()            ),
            ExecutorImpl()
        )
        
        subject.getCountries(cacheSequence: 1) {
            do {
                let countries = try $0.get()
                let afghanistanCountry = countries.countryByCode(code: VCLCountries.Codes.AF)!
                let afghanistanRegions = afghanistanCountry.regions!
                
                assert(afghanistanCountry.code == CountriesMocks.AfghanistanCode)
                assert(afghanistanCountry.name == CountriesMocks.AfghanistanName)
                
                assert(afghanistanRegions.all[0].name == CountriesMocks.AfghanistanRegion1Name)
                assert(afghanistanRegions.all[0].code == CountriesMocks.AfghanistanRegion1Code)
                assert(afghanistanRegions.all[1].name == CountriesMocks.AfghanistanRegion2Name)
                assert(afghanistanRegions.all[1].code == CountriesMocks.AfghanistanRegion2Code)
                assert(afghanistanRegions.all[2].name == CountriesMocks.AfghanistanRegion3Name)
                assert(afghanistanRegions.all[2].code == CountriesMocks.AfghanistanRegion3Code)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    override func tearDown() {
    }
}
