//
//  CredentialTypeSchemasModel.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypeSchemasModel: Model {
    var data: VCLCredentialTypeSchemas? { get }
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void
    )
}
