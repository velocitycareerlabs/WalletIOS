//
//  CredentialTypeSchemaRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypeSchemaRepository: Sendable {
    func getCredentialTypeSchema(
        schemaName: String,
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypeSchema>) -> Void
    )
}
