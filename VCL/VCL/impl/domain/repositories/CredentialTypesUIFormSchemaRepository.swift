//
//  CredentialTypesFormSchemaRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//

import Foundation

protocol CredentialTypesUIFormSchemaRepository {
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        countries: VCLCountries,
        completionBlock: @escaping (VCLResult<VCLCredentialTypesUIFormSchema>) -> Void
    )
}
