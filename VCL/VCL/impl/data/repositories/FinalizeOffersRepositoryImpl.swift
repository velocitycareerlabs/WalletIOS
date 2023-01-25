//
//  FinalizeOffersRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class FinalizeOffersRepositoryImpl: FinalizeOffersRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func finalizeOffers(token: VCLToken,
                        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
                        completionBlock: @escaping (VCLResult<[String]>) -> Void) {
        networkService.sendRequest(
            endpoint: finalizeOffersDescriptor.finalizeOffersUri,
            body: finalizeOffersDescriptor.payload.toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (HeaderKeys.HeaderKeyAuthorization, "\(HeaderKeys.HeaderValuePrefixBearer) \(token.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderKValues.XVnfProtocolVersion)
            ]
        ) { response in
            do {
                let finalizedOffersResponse = try response.get()
                if let encodedJwts = finalizedOffersResponse.payload.toList() as? [String] {
                    completionBlock(.success(encodedJwts))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: finalizedOffersResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
