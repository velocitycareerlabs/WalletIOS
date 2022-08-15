//
//  CredentialTypeSchemaRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

import Foundation

protocol CredentialTypeSchemaRepository {
    func getCredentialTypeSchema(schemaName: String, completionBlock: @escaping (VCLResult<VCLCredentialTypeSchema>) -> Void)
}
