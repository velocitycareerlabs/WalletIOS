//
//  CredentialTypesUIFormSchemaRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialTypesUIFormSchemaRepositoryImpl: CredentialTypesUIFormSchemaRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        countries: VCLCountries,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypesUIFormSchema>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.CredentialTypesFormSchema.replacingOccurrences(of: Params.CredentialType, with: credentialTypesUIFormSchemaDescriptor.credentialType),
            contentType: .ApplicationJson,
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { [weak self] response in
                do {
                    let credentialTypesUiFoermResponse = try response.get()
                    if let self = self, let credentialTypesUiFoerm = credentialTypesUiFoermResponse.payload.toDictionary() {
                        let regions = countries.countryByCode(code: credentialTypesUIFormSchemaDescriptor.countryCode)?.regions
                        completionBlock(.success(
                            VCLCredentialTypesUIFormSchema(
                                payload:
                                    self.parseCredentialTypesUIFormSchema(
                                        credentialTypesUIFormSchemaDescriptor,
                                        countries,
                                        regions,
                                        credentialTypesUiFoerm
                                    )))
                        )
                    } else {
                        completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: credentialTypesUiFoermResponse.payload, encoding: .utf8) ?? "")")))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
    
    private func parseCredentialTypesUIFormSchema(
        _ credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        _ countries: VCLCountries,
        _ regions: VCLRegions?,
        _ formSchemaDict: [String: Sendable]
    ) -> [String: Sendable] {
        var formSchemaDictCP = formSchemaDict
        for (key, value) in formSchemaDictCP {
            if let valueDict = value as? [String: Sendable] {
                if key == VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressCountry {
                    if let allCountries = countries.all {
                        formSchemaDictCP = updateAddressEnums(
                            allCountries,
                            key,
                            valueDict,
                            formSchemaDictCP
                        )
                    }
                } else if key == VCLCredentialTypesUIFormSchema.CodingKeys.KeyAddressRegion {
                    if let allRegions = regions?.all {
                        formSchemaDictCP = updateAddressEnums(
                            allRegions,
                            key,
                            valueDict,
                            formSchemaDictCP
                        )
                    }
                } else {
                    formSchemaDictCP[key] = parseCredentialTypesUIFormSchema(
                        credentialTypesUIFormSchemaDescriptor,
                        countries,
                        regions,
                        valueDict
                    )
                }
            }
        }
        return formSchemaDictCP
    }
    
    private func updateAddressEnums(
        _ places: [VCLPlace],
        _ key: String,
        _ valueDict: [String: Sendable],
        _ formSchemaDict: [String: Sendable]
    ) -> [String: Sendable] {
        var formSchemaDictCP = formSchemaDict
        var valueDictCP = valueDict
        let valueDictHasKeyUiEnum = valueDictCP[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] != nil
        let valueDictHasKeyUiNames = valueDictCP[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] != nil
        if (valueDictHasKeyUiEnum || valueDictHasKeyUiNames) {
            var uiEnumArr = [String]()
            var uiNamesArr = [String]()
            places.forEach { place in
                if(valueDictHasKeyUiEnum) {
                    uiEnumArr.append(place.code)
                }
                if(valueDictHasKeyUiNames) {
                    uiNamesArr.append(place.name)
                }
            }
            if(valueDictHasKeyUiEnum) {
                valueDictCP[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiEnum] = uiEnumArr
            }
            if(valueDictHasKeyUiNames) {
                valueDictCP[VCLCredentialTypesUIFormSchema.CodingKeys.KeyUiNames] = uiNamesArr
            }
            formSchemaDictCP[key] = valueDictCP
        }
        return formSchemaDictCP
    }
}
