//
//  CredentialManifestRepository.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialManifestRepository: Sendable {
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        completionBlock: @escaping @Sendable (VCLResult<String>) -> Void
    )
}
