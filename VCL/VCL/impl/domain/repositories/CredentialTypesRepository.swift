//
//  CredentialTypesRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypesRepository: Sendable {
    func getCredentialTypes(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypes>) -> Void
    )
}
