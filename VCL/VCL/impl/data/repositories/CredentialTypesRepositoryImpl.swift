//
//  CredentialTypesRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialTypesRepositoryImpl: CredentialTypesRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialTypes(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void) {
        networkService.sendRequest(endpoint: Urls.CredentialTypes,
                                   contentType: .ApplicationJson,
                                   method: .GET,
                                   cachePolicy: .useProtocolCachePolicy) { response in
            do {
                if let credentialTypesList = try response.get().payload.toList() as? [[String: Any]?] {
                    completionBlock(.success(self.parse(credentialTypesList)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse VCLCredentialTypes)")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(_ credentialTypesList: [[String: Any]?]) -> VCLCredentialTypes {
        var credentialTypesArr = [VCLCredentialType]()
        for i in 0..<credentialTypesList.count {
            if let payload = credentialTypesList[i] {
                let id = payload[VCLCredentialType.CodingKeys.KeyId] as? String
                let schema = payload[VCLCredentialType.CodingKeys.KeySchema] as? String
                let createdAt = payload[VCLCredentialType.CodingKeys.KeyCreatedAt] as? String
                let schemaName = payload[VCLCredentialType.CodingKeys.KeySchemaName] as? String
                let credentialType = payload[VCLCredentialType.CodingKeys.KeyCredentialType] as? String
                let recommended = payload[VCLCredentialType.CodingKeys.KeyRecommended] as? Bool

                credentialTypesArr.append(
                    VCLCredentialType(
                        payload: payload,
                        id: id,
                        schema: schema,
                        createdAt: createdAt,
                        schemaName: schemaName,
                        credentialType: credentialType,
                        recommended: recommended
                    )
                )
            }
        }
        return VCLCredentialTypes(all: credentialTypesArr)
    }
}

