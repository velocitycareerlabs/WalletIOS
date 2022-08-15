//
//  CredentialTypesModel.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//

import Foundation

protocol CredentialTypesModel: Model {
    var data: VCLCredentialTypes? { get }
    func initialize(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void)
}
