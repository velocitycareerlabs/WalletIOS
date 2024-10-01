//
//  CountriesRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class CountriesRepositoryImpl: CountriesRepository {
    
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(_ networkService: NetworkService, _ cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getCountries(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCountries>) -> Void
    ) {
        let endpoint = Urls.Countries
        if (cacheService.isResetCacheCountries(cacheSequence: cacheSequence)) {
            fetchCountries(endpoint: endpoint, cacheSequence: cacheSequence, completionBlock: completionBlock)
        } else {
            if let countries = cacheService.getCountries(key: endpoint) {
                if let countriesList = countries.toList() {
                    completionBlock(.success(self.listToCountries(countriesList as? [[String: Sendable]])))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(countries)")))
                }
            } else {
                fetchCountries(endpoint: endpoint, cacheSequence: cacheSequence, completionBlock: completionBlock)
            }
        }
    }
    
    private func fetchCountries(
        endpoint: String,
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCountries>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: endpoint,
            contentType: .ApplicationJson,
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            cachePolicy: .useProtocolCachePolicy
        ) {
            [weak self] res in
            do {
                let payload = try res.get().payload
                self?.cacheService.setCountries(key: endpoint, value: payload, cacheSequence: cacheSequence)
                if let countriesList = payload.toList() as? [[String: Sendable]], let self = self {
                    completionBlock(.success(self.listToCountries(countriesList)))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func listToCountries(_ countriesDictArr: [[String: Sendable]]?) -> VCLCountries {
        var countries = [VCLCountry]()
        countriesDictArr?.forEach{
            countries.append(parseCountry($0))
        }
        return VCLCountries(all: countries)
    }
    
    private func parseCountry(_ countryDict: [String: Sendable]) -> VCLCountry {
        var regions: VCLRegions? = nil

        if let dictArrRegions = countryDict[VCLCountry.Codes.KeyRegions] as? [[String: Sendable]] {
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
