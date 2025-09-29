//
//  CredentialTypeSchemasUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialTypeSchemasMapStorage {
    private var credentialTypeSchemasMap: [String: VCLCredentialTypeSchema] = [:]
    private let queue = DispatchQueue(label: "CredentialTypeSchemasMapStorage.queue", attributes: .concurrent)
    
    func add(schemaName: String, schema: VCLCredentialTypeSchema) {
        queue.async(flags: .barrier) {
            self.credentialTypeSchemasMap[schemaName] = schema
        }
    }
    
    func isEmpty() -> Bool {
        queue.sync {
            credentialTypeSchemasMap.isEmpty
        }
    }
    
    func get() -> [String: VCLCredentialTypeSchema] {
        queue.sync {
            credentialTypeSchemasMap
        }
    }
}

final class CredentialTypeSchemasUseCaseImpl: CredentialTypeSchemasUseCase {
    
    private let credentialTypeSchemasRepository: CredentialTypeSchemaRepository
    private let credentialTypes: VCLCredentialTypes
    private let executor: Executor
    private let dispatcher: Dispatcher
    
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
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void
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
                        self.credentialTypeSchemasStorage.add(schemaName: schemaName, schema: credentialTypeSchema)
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
                if self.credentialTypeSchemasStorage.isEmpty() {
                    VCLLog.e("Credential type schemas were not found.")
                }
                completionBlock(VCLResult.success(VCLCredentialTypeSchemas(all: self.credentialTypeSchemasStorage.get())))
            }
        }
    }
}
