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
    private let jwtServiceRepository: JwtServiceRepository
    
    init(
        _ networkService: NetworkService,
        _ jwtServiceRepository: JwtServiceRepository
    ) {
        self.networkService = networkService
        self.jwtServiceRepository = jwtServiceRepository
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
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]
        ) { result in
            do {
                let finalizedOffersResponse = try result.get()
                if let encodedJwts = finalizedOffersResponse.payload.toList() as? [String] {
                    completionBlock(.success(encodedJwts))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: finalizedOffersResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
