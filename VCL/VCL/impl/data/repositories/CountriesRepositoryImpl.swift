//
//  CountriesRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CountriesRepositoryImpl: CountriesRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCountries(completionBlock: @escaping (VCLResult<VCLCountries>) -> Void) {
        networkService.sendRequest(endpoint: Urls.Countries,
                                   contentType: .ApplicationJson,
                                   method: .GET,
                                   cachePolicy: .useProtocolCachePolicy) {
            [weak self] res in
            do {
                let countriesResponse = try res.get()
                if let countriesList = countriesResponse.payload.toList(), let _self = self {
                    completionBlock(.success(_self.listToCountries(countriesList as? [[String: Any]])))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: countriesResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func listToCountries(_ countriesDictArr: [[String: Any]]?) -> VCLCountries {
        var countries = [VCLCountry]()
        countriesDictArr?.forEach{
            countries.append(parseCountry($0))
        }
        return VCLCountries(all: countries)
    }
    
    private func parseCountry(_ countryDict: [String: Any]) -> VCLCountry {
        var regions: VCLRegions? = nil

        if let dictArrRegions = countryDict[VCLCountry.Codes.KeyRegions] as? [[String: Any]] {
            var regionsList = [VCLRegion]()
            dictArrRegions.forEach { regionDict in
                regionsList.append(VCLRegion(
                    payload: regionDict,
                    code: regionDict[VCLRegion.Codes.KeyCode] as? String ?? "",
                    name: regionDict[VCLRegion.Codes.KeyName] as? String ?? ""
                ))
            }
            regions = VCLRegions(all: regionsList)
        }

        return VCLCountry(
            payload: countryDict,
            code: countryDict[VCLCountry.Codes.KeyCode] as? String ?? "",
            name: countryDict[VCLCountry.Codes.KeyName] as? String ?? "",
            regions: regions
        )
    }
}
