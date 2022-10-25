//
//  CredentialTypesModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

class CredentialTypesModelImpl: CredentialTypesModel {
    
    private(set) var data: VCLCredentialTypes? = nil
    let credentialTypesUseCase: CredentialTypesUseCase
    
    init(_ credentialTypesUseCase: CredentialTypesUseCase) {
        self.credentialTypesUseCase = credentialTypesUseCase
    }
    
    func initialize(
        resetCache: Bool,
        completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void
    ) {
        credentialTypesUseCase.getCredentialTypes(resetCache: resetCache) { [weak self] response in
            do {
                self?.data = try response.get()
            } catch {}
            completionBlock(response)
        }
    }
}
