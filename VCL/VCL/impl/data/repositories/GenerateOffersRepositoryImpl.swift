//
//  GenerateOffersRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class GenerateOffersRepositoryImpl: GenerateOffersRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: generateOffersDescriptor.checkOffersUri,
            body: generateOffersDescriptor.payload.toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (HeaderKeys.Authorization, "\(HeaderValues.PrefixBearer) \(sessionToken.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]
        ) { response in
            do {
                let offersResponse = try response.get()
                completionBlock(.success(
                    VCLOffers.fromPayload(
                        payloadData: offersResponse.payload,
                        responseCode: offersResponse.code,
                        sessionToken: sessionToken
                    )
                ))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
