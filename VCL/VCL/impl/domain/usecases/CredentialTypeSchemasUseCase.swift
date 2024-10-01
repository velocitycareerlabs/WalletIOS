//
//  CredentialTypeSchemasUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

protocol CredentialTypeSchemasUseCase: Sendable {
    func getCredentialTypeSchemas(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypeSchemas>) -> Void
    )
}
