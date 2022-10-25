//
//  CredentialTypesRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypesRepository {
    func getCredentialTypes(resetCache: Bool, completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void)
}
