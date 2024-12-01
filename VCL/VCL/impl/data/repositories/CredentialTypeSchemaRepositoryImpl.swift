//
//  CredentialTypeSchemaRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialTypeSchemaRepositoryImpl: CredentialTypeSchemaRepository {
    
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(_ networkService: NetworkService, _ cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getCredentialTypeSchema(
        schemaName: String,
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchema>) -> Void
    ) {
        let endpoint = Urls.CredentialTypeSchemas + schemaName
        if(cacheService.isResetCacheCredentialTypeSchema(cacheSequence: cacheSequence)) {
            fetchCredentialTypeSchema(endpoint: endpoint, cacheSequence: cacheSequence, completionBlock: completionBlock)
        } else {
            if let credentialTypeSchema = cacheService.getCredentialTypeSchema(key: endpoint) {
                if let payload = credentialTypeSchema.toDictionary() {
                    completionBlock(.success(VCLCredentialTypeSchema(payload: payload)))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(credentialTypeSchema)")))
                }
            } else {
                fetchCredentialTypeSchema(endpoint: endpoint, cacheSequence: cacheSequence, completionBlock: completionBlock)
            }
        }
    }
    
    private func fetchCredentialTypeSchema(
        endpoint: String,
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchema>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: endpoint,
            contentType: .ApplicationJson,
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            cachePolicy: .useProtocolCachePolicy) {
            [weak self] res in
            do {
                let payload = try res.get().payload
                self?.cacheService.setCredentialTypeSchema(key: endpoint, value: payload, cacheSequence: cacheSequence)
                if let credentialTypeSchemaList = payload.toDictionary() {
                    completionBlock(.success(VCLCredentialTypeSchema(payload: credentialTypeSchemaList)))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
