//
//  CredentialSubjectContextRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 28/09/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

protocol CredentialSubjectContextRepository {
    func getCredentialSubjectContext(
        credentialSubjectContextEndpoint: String,
        completionBlock: @escaping (VCLResult<[String: Any]>) -> Void
    )
}
