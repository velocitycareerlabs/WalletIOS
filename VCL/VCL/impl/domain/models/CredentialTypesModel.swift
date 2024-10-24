//
//  CredentialTypesModel.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypesModel: Model {
    var data: VCLCredentialTypes? { get }
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypes>) -> Void
    )
    func credentialTypeByTypeName(type: String) -> VCLCredentialType?
}
