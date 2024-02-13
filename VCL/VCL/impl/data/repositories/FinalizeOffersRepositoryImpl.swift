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
    
    init(
        _ networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        proof: VCLJwt? = nil,
        completionBlock: @escaping (VCLResult<[VCLJwt]>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: finalizeOffersDescriptor.finalizeOffersUri,
            body: finalizeOffersDescriptor.generateRequestBody(proof: proof).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (HeaderKeys.Authorization, "\(HeaderKeys.Bearer) \(sessionToken.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]
        ) { result in
            do {
                let finalizedOffersResponse = try result.get()
                if let jwts = finalizedOffersResponse.payload.toJwtList() {
                    completionBlock(.success(jwts))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: finalizedOffersResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
