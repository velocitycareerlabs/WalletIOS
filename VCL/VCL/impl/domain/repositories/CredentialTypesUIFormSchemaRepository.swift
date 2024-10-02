//
//  CredentialTypesFormSchemaRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialTypesUIFormSchemaRepository: Sendable {
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        countries: VCLCountries,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypesUIFormSchema>) -> Void
    )
}
