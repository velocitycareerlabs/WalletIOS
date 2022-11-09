//
//  CredentialTypeSchemasModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

class CredentialTypeSchemasModelImpl: CredentialTypeSchemasModel {
    
    private(set) var data: VCLCredentialTypeSchemas?
    let credentialTypeSchemasUseCase: CredentialTypeSchemasUseCase
    
    init(_ credentialTypeSchemasUseCase: CredentialTypeSchemasUseCase) {
        self.credentialTypeSchemasUseCase = credentialTypeSchemasUseCase
    }
    
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void
    ) {
        credentialTypeSchemasUseCase.getCredentialTypeSchemas(cacheSequence: cacheSequence) { [weak self] result in
            do {
                self?.data = try result.get()
            } catch {}
            completionBlock(result)
        }
    }
}
