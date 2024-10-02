//
//  CredentialTypeSchemasUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

actor CredentialTypeSchemasMapStorage {
    private var credentialTypeSchemasMap: [String: VCLCredentialTypeSchema] = [:]
    
    func add(schemaName: String, schema: VCLCredentialTypeSchema) {
        credentialTypeSchemasMap[schemaName] = schema
    }
    
    func isEmpty() -> Bool {
        return credentialTypeSchemasMap.isEmpty
    }
    
    func get() -> [String: VCLCredentialTypeSchema] {
        return credentialTypeSchemasMap
    }
}

final class CredentialTypeSchemasUseCaseImpl: Sendable, CredentialTypeSchemasUseCase {
    
    private let credentialTypeSchemasRepository: CredentialTypeSchemaRepository
    private let credentialTypes: VCLCredentialTypes
    private let executor: Executor
    private let dispatcher: Dispatcher
    
    // Actor to manage the state of credentialTypeSchemasMap safely across threads
    private let credentialTypeSchemasStorage = CredentialTypeSchemasMapStorage()
    
    init(
        _ credentialTypeSchemasRepository: CredentialTypeSchemaRepository,
        _ credentialTypes: VCLCredentialTypes,
        _ executor: Executor,
       _  dispatcher: Dispatcher
    ) {
        self.credentialTypeSchemasRepository = credentialTypeSchemasRepository
        self.credentialTypes = credentialTypes
        self.executor = executor
        self.dispatcher = dispatcher
    }
    
    func getCredentialTypeSchemas(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypeSchemas>) -> Void
    ) {
        let schemaNamesArr = self.credentialTypes.all?.compactMap { $0.schemaName } ?? []
                
        schemaNamesArr.forEach { schemaName in
            dispatcher.enter()
            executor.runOnBackground {
                self.credentialTypeSchemasRepository.getCredentialTypeSchema(
                    schemaName: schemaName,
                    cacheSequence: cacheSequence
                ) {
                    [weak self] result in
                    
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let credentialTypeSchema):
                        Task {
                            // Safely update the actor-managed map
                            await self.credentialTypeSchemasStorage.add(schemaName: schemaName, schema: credentialTypeSchema)
                        }
                    case .failure:
                        // Ignore errors
                        break
                    }
                    dispatcher.leave()
                }
            }
        }
        
        dispatcher.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.executor.runOnMain {
                Task { [weak self] in
                    guard let self = self else { return }
                    if await self.credentialTypeSchemasStorage.isEmpty() {
                        VCLLog.e("Credential type schemas were not found.")
                    }
                    completionBlock(VCLResult.success(VCLCredentialTypeSchemas(all: await self.credentialTypeSchemasStorage.get())))
                }
            }
        }
    }
}
