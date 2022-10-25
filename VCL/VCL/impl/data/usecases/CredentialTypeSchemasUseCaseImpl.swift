//
//  CredentialTypeSchemasUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialTypeSchemasUseCaseImpl: CredentialTypeSchemasUseCase {
    
    private let credentialTypeSchemasRepository: CredentialTypeSchemaRepository
    private let credenctiialTypes: VCLCredentialTypes
    private let executor: Executor
    private let dispatcher: Dispatcher
    private let dsptchQueue: DsptchQueue
        
    init(_ credentialTypeSchemasRepository: CredentialTypeSchemaRepository,
         _ credenctiialTypes: VCLCredentialTypes,
         _ executor: Executor,
         _ dispatcher: Dispatcher,
         _ dsptchQueue: DsptchQueue) {
        self.credentialTypeSchemasRepository = credentialTypeSchemasRepository
        self.credenctiialTypes = credenctiialTypes
        self.executor = executor
        self.dispatcher = dispatcher
        self.dsptchQueue = dsptchQueue
    }
    
    func getCredentialTypeSchemas(
        resetCache: Bool,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void
    ) {
        var credentialTypeSchemasMap = [String: VCLCredentialTypeSchema]()
        var credentialTypeSchemasMapIsEmpty = true
        
        executor.runOnBackgroundThread { [weak self] in
            let schemaNamesArr =
                self?.credenctiialTypes.all?.filter { $0.schemaName != nil }.map { $0.schemaName! } ?? Array()
            
            schemaNamesArr.forEach { schemaName in
                self?.dispatcher.enter()
                self?.credentialTypeSchemasRepository.getCredentialTypeSchema(
                    schemaName: schemaName,
                    resetCache: resetCache,
                    completionBlock: { result in
                        do {
                            let credentialTypeSchema = try result.get()
                            self?.dsptchQueue._async(flags: .barrier) {
                                credentialTypeSchemasMap.updateValue(credentialTypeSchema, forKey: schemaName)
                                credentialTypeSchemasMapIsEmpty = credentialTypeSchemasMap.isEmpty
                            }
                        } catch {
                            // no need to handle
                        }
                        self?.dispatcher.leave()
                    }
                )
            }
            self?.dispatcher.notify(queue: .main) {
                if(credentialTypeSchemasMapIsEmpty) {
                    completionBlock(.failure(VCLError(description: "Failed to fetch credential type schemas")))
                } else {
                    completionBlock(.success(VCLCredentialTypeSchemas(all: credentialTypeSchemasMap)))
                }
            }
        }
    }
}
