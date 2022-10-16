//
//  CredentialTypeSchemaRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypeSchemaRepository {
    func getCredentialTypeSchema(schemaName: String, completionBlock: @escaping (VCLResult<VCLCredentialTypeSchema>) -> Void)
}
