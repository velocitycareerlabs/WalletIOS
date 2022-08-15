//
//  CredentialTypeSchemaRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

import Foundation

class CredentialTypeSchemaRepositoryImpl: CredentialTypeSchemaRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialTypeSchema(
        schemaName: String, completionBlock: @escaping (VCLResult<VCLCredentialTypeSchema>) -> Void
    ) {
        networkService.sendRequest(endpoint: Urls.CredentialTypeSchemas + schemaName,
                                   contentType: .ApplicationJson,
                                   method: .GET,
                                   cachePolicy: .useProtocolCachePolicy) { response in
            do {
                let credentialTypeSchemaResponse = try response.get()
                if let payload = credentialTypeSchemaResponse.payload.toDictionary() {
                    completionBlock(.success(VCLCredentialTypeSchema(payload: payload)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: credentialTypeSchemaResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
