//
//  ResolveKidRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ResolveKidRepositoryImpl: ResolveKidRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPublicKey(keyID: String, completionBlock: @escaping (VCLResult<VCLJwkPublic>) -> Void) {
        networkService.sendRequest(endpoint: Urls.ResolveKid + keyID + "?format=\(VCLJwkPublic.Format.jwk)",
                                   contentType: Request.ContentType.ApplicationJson,
                                   method: Request.HttpMethod.GET) {
            response in
            do{
                let publicKeyResponse = try response.get()
                if let jwkDict = publicKeyResponse.payload.toDictionary() {
                    completionBlock(.success(VCLJwkPublic(valueDict: jwkDict)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: publicKeyResponse.payload, encoding: .utf8) ?? "")")))
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
