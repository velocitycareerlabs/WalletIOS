//
//  CountriesUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 13/12/2021.
//

import Foundation
import XCTest
@testable import VCL

final class CountriesUseCaseTest: XCTestCase {
    
    var subject: CountriesUseCase? = nil
    
    override func setUp() {
    }
    
    func testGetCountriesSuccess() {
//        Arrange
        subject = CountriesUseCaseImpl(
            CountriesRepositoryImpl(
                NetworkServiceSuccess(
                    validResponse: CountriesMocks.CountriesJson
                )            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLCountries>? = nil
        
//        Action
        subject?.getCountries {
            result = $0
        }
        do {
            let countries = try result?.get()
            let afghanistanCountry = countries?.countryByCode(code: VCLCountries.Codes.AF)!
            let afghanistanRegions = afghanistanCountry?.regions!
            
            assert(afghanistanCountry?.code == CountriesMocks.AfghanistanCode)
            assert(afghanistanCountry?.name == CountriesMocks.AfghanistanName)
            
            assert(afghanistanRegions!.all[0].name == CountriesMocks.AfghanistanRegion1Name)
            assert(afghanistanRegions!.all[0].code == CountriesMocks.AfghanistanRegion1Code)
            assert(afghanistanRegions!.all[1].name == CountriesMocks.AfghanistanRegion2Name)
            assert(afghanistanRegions!.all[1].code == CountriesMocks.AfghanistanRegion2Code)
            assert(afghanistanRegions!.all[2].name == CountriesMocks.AfghanistanRegion3Name)
            assert(afghanistanRegions?.all[2].code == CountriesMocks.AfghanistanRegion3Code)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
    }
}
