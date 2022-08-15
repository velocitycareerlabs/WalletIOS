//
//  CredentialManifestRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//

import Foundation

class CredentialManifestRepositoryImpl: CredentialManifestRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialManifest(credentialManifestDescriptor: VCLCredentialManifestDescriptor,
                               completionBlock: @escaping (VCLResult<String>) -> Void) {        
        networkService.sendRequest(endpoint:credentialManifestDescriptor.endpoint,
                                   contentType: .ApplicationJson,
                                   method: .GET) { response in
            do {
                let credentialManifestReposnse = try response.get()
                if let jwtStr = credentialManifestReposnse.payload.toDictionary()?[VCLCredentialManifest.CodingKeys.KeyIssuingRequest] as? String {
                    completionBlock(.success(jwtStr))
                    
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: credentialManifestReposnse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}

