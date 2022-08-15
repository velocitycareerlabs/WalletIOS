//
//  CredentialTypesRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//

import Foundation

protocol CredentialTypesRepository {
    func getCredentialTypes(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void)
}
