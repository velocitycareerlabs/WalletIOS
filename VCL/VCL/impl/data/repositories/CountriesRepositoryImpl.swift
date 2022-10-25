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
    private let cacheService: CacheService
    
    init(_ networkService: NetworkService, _ cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getCountries(
        resetCache: Bool,
        completionBlock: @escaping (VCLResult<VCLCountries>) -> Void
    ) {
        let endpoint = Urls.Countries
        if (resetCache) {
            fetchCountries(endpoint: endpoint, completionBlock: completionBlock)
        } else {
            if let countries = cacheService.getCountries(keyUrl: endpoint) {
                if let countriesList = countries.toList() {
                    completionBlock(.success(self.listToCountries(countriesList as? [[String: Any]])))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(countries)")))
                }
            } else {
                fetchCountries(endpoint: endpoint, completionBlock: completionBlock)
            }
        }
    }
    
    private func fetchCountries(endpoint: String, completionBlock: @escaping (VCLResult<VCLCountries>) -> Void) {
        networkService.sendRequest(endpoint: endpoint,
                                   contentType: .ApplicationJson,
                                   method: .GET,
                                   cachePolicy: .useProtocolCachePolicy) {
            [weak self] res in
            do {
                let payload = try res.get().payload
                self?.cacheService.setCountries(keyUrl: endpoint, value: payload)
                if let countriesList = payload.toList() as? [[String: Any]], let _self = self {
                    completionBlock(.success(_self.listToCountries(countriesList)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: payload, encoding: .utf8) ?? "")")))
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
