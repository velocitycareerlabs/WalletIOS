//
//  CredentialTypesUIFormSchemaUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CredentialTypesUIFormSchemaUseCaseTest: XCTestCase {
    
    private var subject1: CredentialTypesUIFormSchemaUseCase!
    private var subject2: CredentialTypesUIFormSchemaUseCase!
    private var subject3: CredentialTypesUIFormSchemaUseCase!
    private var subject4: CredentialTypesUIFormSchemaUseCase!
    private var subject5: CredentialTypesUIFormSchemaUseCase!
    
    private var mockedCountries: VCLCountries!
    
    override func setUp() {
        mockedCountries = jsonArrToCountries(CredentialTypesUIFormSchemaMocks.CountriesJson.toList() as! [[String: Any]])
    }
    
    func testCredentialTypesFormSchemaFull() {
        subject1 = CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypesUIFormSchemaMocks.UISchemaFormJsonFull)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )

        subject1.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor:VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: "some type", countryCode: VCLCountries.Codes.CA
            ),
            countries: mockedCountries
        ) {
            do {
                let addressJsonObj = try $0.get().payload["place"] as! [String: Any]
                let addressCountryJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressCountry] as! [String: Any]
                let addressRegionJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressRegion] as! [String: Any]
                
                let expectedAddressCountryCodes = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressCountryNames = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as! [String]
                
                let expectedAddressRegionCodes = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressRegionNames = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as! [String]
                
                assert(expectedAddressCountryCodes == CredentialTypesUIFormSchemaMocks.CountryCodes.toList()!)
                assert(expectedAddressCountryNames == CredentialTypesUIFormSchemaMocks.CountryNames.toList()!)
                assert(expectedAddressRegionCodes == CredentialTypesUIFormSchemaMocks.CanadaRegionCodes.toList()!)
                assert(expectedAddressRegionNames == CredentialTypesUIFormSchemaMocks.CanadaRegionNames.toList()!)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testCredentialTypesFormSchemaOnlyCountries() {
        subject2 = CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypesUIFormSchemaMocks.UISchemaFormJsonOnlyCountries)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )

        subject2.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor:VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: "some type", countryCode: VCLCountries.Codes.CA
            ),
            countries: mockedCountries
        ) {
            do {
                let addressJsonObj = try $0.get().payload["place"] as! [String: Any]
                let addressCountryJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressCountry] as! [String: Any]
                let addressRegionJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressRegion] as! [String: Any]
                
                let expectedAddressCountryCodes = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressCountryNames = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as! [String]
                
                let expectedAddressRegionCodes = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as? [String]
                let expectedAddressRegionNames = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as? [String]
                
                assert(expectedAddressCountryCodes == CredentialTypesUIFormSchemaMocks.CountryCodes.toList()!)
                assert(expectedAddressCountryNames == CredentialTypesUIFormSchemaMocks.CountryNames.toList()!)
                assert(expectedAddressRegionCodes == nil)
                assert(expectedAddressRegionNames == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testCredentialTypesFormSchemaOnlyRegions() {
        subject3 = CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypesUIFormSchemaMocks.UISchemaFormJsonOnlyRegions)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        
        subject3.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor:VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: "some type", countryCode: VCLCountries.Codes.CA
            ),
            countries: mockedCountries
        ) {
            do {
                let addressJsonObj = try $0.get().payload["place"] as! [String: Any]
                let addressCountryJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressCountry] as! [String: Any]
                let addressRegionJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressRegion] as! [String: Any]
                
                let expectedAddressCountryCodes = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as? [String]
                let expectedAddressCountryNames = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as? [String]
                
                let expectedAddressRegionCodes = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressRegionNames = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as! [String]
                
                assert(expectedAddressCountryCodes == nil)
                assert(expectedAddressCountryNames == nil)
                assert(expectedAddressRegionCodes == CredentialTypesUIFormSchemaMocks.CanadaRegionCodes.toList()!)
                assert(expectedAddressRegionNames == CredentialTypesUIFormSchemaMocks.CanadaRegionNames.toList()!)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testCredentialTypesFormSchemaOnlyEnums() {
        subject4 = CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypesUIFormSchemaMocks.UISchemaFormJsonOnlyEnums)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )

        subject4.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor:VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: "some type", countryCode: VCLCountries.Codes.CA
            ),
            countries: mockedCountries
        ) {
            do {
                let addressJsonObj = try $0.get().payload["place"] as! [String: Any]
                let addressCountryJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressCountry] as! [String: Any]
                let addressRegionJsonObj = addressJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressRegion] as! [String: Any]
                
                let expectedAddressCountryCodes = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressCountryNames = addressCountryJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as? [String]
                
                let expectedAddressRegionCodes = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] as! [String]
                let expectedAddressRegionNames = addressRegionJsonObj[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] as? [String]
                
                assert(expectedAddressCountryCodes == CredentialTypesUIFormSchemaMocks.CountryCodes.toList()!)
                assert(expectedAddressCountryNames == nil)
                assert(expectedAddressRegionCodes == CredentialTypesUIFormSchemaMocks.CanadaRegionCodes.toList()!)
                assert(expectedAddressRegionNames == nil)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testCredentialTypesFormSchemaFailure() {
        subject5 = CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: "wrong payload")
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        
        subject5.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: "some type", countryCode: VCLCountries.Codes.CA
            ),
            countries: mockedCountries
        ) {
            do  {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.SdkError.rawValue) error code is expected")
            }
            catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.SdkError.rawValue)
            }
        }
    }
    
    private func jsonArrToCountries(_ countriesArr: [[String: Any]]) -> VCLCountries {
        var countries = [VCLCountry]()
        for i in 0..<countriesArr.count {
            countries.append(parseCountry(countriesArr[i]))
        }
        return VCLCountries(all: countries)
    }
    
    private func parseCountry(_ countryDict: [String: Any]) -> VCLCountry {
        var regions: VCLRegions? = nil
        
        if let regionsArr = countryDict[VCLCountry.Codes.KeyRegions] as? [[String: Any]] {
            var regionsList = [VCLRegion]()
            for i in 0..<regionsArr.count {
                regionsList.append(VCLRegion(
                    payload: regionsArr[i],
                    code: (regionsArr[i] as! [String: String])[VCLRegion.Codes.KeyCode]!,
                    name: (regionsArr[i] as! [String: String])[VCLRegion.Codes.KeyName]!
                ))
            }
            regions = VCLRegions(all: regionsList)
        }
        
        return VCLCountry(
            payload: countryDict,
            code: countryDict[VCLCountry.Codes.KeyCode]! as! String,
            name: countryDict[VCLCountry.Codes.KeyName]! as! String,
            regions: regions
        )
    }
    
    override func tearDown() {
    }
}
