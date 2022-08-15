//
//  CredentialManifestUseCase.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//

import Foundation

protocol CredentialManifestUseCase {
    func getCredentialManifest(credentialManifestDescriptor: VCLCredentialManifestDescriptor,
                              completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void)
}
