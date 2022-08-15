//
//  CredentialTypesUIFormSchemaRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//

import Foundation

class CredentialTypesUIFormSchemaRepositoryImpl: CredentialTypesUIFormSchemaRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        countries: VCLCountries,
        completionBlock: @escaping (VCLResult<VCLCredentialTypesUIFormSchema>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.CredentialTypesFormSchema.replacingOccurrences(of: Params.CredentialType, with: credentialTypesUIFormSchemaDescriptor.credentialType),
            contentType: .ApplicationJson,
            method: .GET) { [weak self] response in
                do {
                    let credentialTypesUiFoermResponse = try response.get()
                    if let _self = self, let credentialTypesUiFoerm = credentialTypesUiFoermResponse.payload.toDictionary() {
                        let regions = countries.countryByCode(code: credentialTypesUIFormSchemaDescriptor.countryCode)?.regions
                        completionBlock(.success(
                            VCLCredentialTypesUIFormSchema(
                                payload:
                                    _self.parseCredentialTypesUIFormSchema(
                                        credentialTypesUIFormSchemaDescriptor,
                                        countries,
                                        regions,
                                        credentialTypesUiFoerm
                                    )))
                        )
                    } else {
                        completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: credentialTypesUiFoermResponse.payload, encoding: .utf8) ?? "")")))
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
        _ formSchemaDict: [String: Any]
    ) -> [String: Any] {
        var formSchemaDictCP = formSchemaDict
        for (key, value) in formSchemaDictCP {
            if let valueDict = value as? [String: Any] {
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
        _ valueDict: [String: Any],
        _ formSchemaDict: [String: Any]
    ) -> [String: Any] {
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
