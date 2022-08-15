//
//  CredentialManifestRepository.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//

import Foundation

protocol CredentialManifestRepository {
    func getCredentialManifest(credentialManifestDescriptor: VCLCredentialManifestDescriptor,
                              completionBlock: @escaping (VCLResult<String>) -> Void)
}
