//
//  CredentialTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//

protocol CredentialTypesUseCase {
    func getCredentialTypes(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void)
}
