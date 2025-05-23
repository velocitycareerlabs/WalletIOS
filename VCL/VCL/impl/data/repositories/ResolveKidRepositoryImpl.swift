//
//  ResolveKidRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ResolveKidRepositoryImpl: ResolveKidRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPublicKey(kid: String, completionBlock: @escaping (VCLResult<VCLPublicJwk>) -> Void) {
        networkService.sendRequest(
            endpoint: Urls.ResolveKid + kid + "?format=\(VCLPublicJwk.Format.jwk)",
            contentType: Request.ContentType.ApplicationJson,
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) {
            response in
            do{
                let publicKeyResponse = try response.get()
                if let jwkDict = publicKeyResponse.payload.toDictionary() {
                    completionBlock(.success(VCLPublicJwk(valueDict: jwkDict)))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: publicKeyResponse.payload, encoding: .utf8) ?? "")")))
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
