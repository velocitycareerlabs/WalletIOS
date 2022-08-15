//
//  CredentialTypeSchemasModel.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

import Foundation

protocol CredentialTypeSchemasModel: Model {
    var data: VCLCredentialTypeSchemas? { get }
    func initialize(completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void)
}
