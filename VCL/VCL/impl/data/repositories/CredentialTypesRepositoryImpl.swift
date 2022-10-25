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
    private let cacheService: CacheService
    
    init(_ networkService: NetworkService, _ cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getCredentialTypes(
        resetCache: Bool,
        completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void
    ) {
        let endpoint = Urls.CredentialTypes
        if(resetCache) {
            fetchCredentialTypes(endpoint: endpoint, completionBlock: completionBlock)
        } else {
            if let credentialTypes = cacheService.getCredentialTypes(keyUrl: endpoint) {
                if let credentialTypesList = credentialTypes.toList() as? [[String: Any]?] {
                    completionBlock(.success(self.parse(credentialTypesList)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse VCLCredentialTypes)")))
                }
            } else {
                fetchCredentialTypes(endpoint: endpoint, completionBlock: completionBlock)
            }
        }
    }
    
    private func fetchCredentialTypes(endpoint: String, completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void) {
        networkService.sendRequest(endpoint: endpoint,
                                   contentType: .ApplicationJson,
                                   method: .GET,
                                   cachePolicy: .useProtocolCachePolicy) {
            [weak self] res in
            do {
                let payload = try res.get().payload
                self?.cacheService.setCredentialTypes(keyUrl: endpoint, value: payload)
                if let credentialTypesList = payload.toList() as? [[String: Any]?], let _self = self {
                    completionBlock(.success(_self.parse(credentialTypesList)))
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

