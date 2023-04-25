//
//  CredentialTypeSchemasUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CredentialTypeSchemasUseCaseImpl: CredentialTypeSchemasUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!

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
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void
    ) {
        var credentialTypeSchemasMap = [String: VCLCredentialTypeSchema]()
        var credentialTypeSchemasMapIsEmpty = true
        
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(CredentialTypeSchemasUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                let schemaNamesArr =
                _self.credenctiialTypes.all?.filter { $0.schemaName != nil }.map { $0.schemaName! } ?? Array()
                
                schemaNamesArr.forEach { schemaName in
                    _self.dispatcher.enter()
                    _self.credentialTypeSchemasRepository.getCredentialTypeSchema(
                        schemaName: schemaName,
                        cacheSequence: cacheSequence,
                        completionBlock: { result in
                            do {
                                let credentialTypeSchema = try result.get()
                                _self.dsptchQueue._async(flags: .barrier) {
                                    credentialTypeSchemasMap.updateValue(credentialTypeSchema, forKey: schemaName)
                                    credentialTypeSchemasMapIsEmpty = credentialTypeSchemasMap.isEmpty
                                }
                            } catch {
                                // no need to handle
                            }
                            _self.dispatcher.leave()
                        }
                    )
                }
                _self.dispatcher.notify(queue: .main) {
                    if(credentialTypeSchemasMapIsEmpty) {
                        VCLLog.e("Failed to fetch credential type schemas")
                    }
                    completionBlock(.success(VCLCredentialTypeSchemas(all: credentialTypeSchemasMap)))
                }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
}
