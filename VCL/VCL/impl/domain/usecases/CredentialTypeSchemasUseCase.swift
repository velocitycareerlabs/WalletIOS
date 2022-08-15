//
//  CredentialTypeSchemasUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

protocol CredentialTypeSchemasUseCase {
    func getCredentialTypeSchemas(completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void)
}
