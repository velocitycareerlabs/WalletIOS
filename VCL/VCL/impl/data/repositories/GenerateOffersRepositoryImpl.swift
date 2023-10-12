//
//  GenerateOffersRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class GenerateOffersRepositoryImpl: GenerateOffersRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        issuingToken: VCLToken,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: generateOffersDescriptor.checkOffersUri,
            body: generateOffersDescriptor.payload.toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (HeaderKeys.Authorization, "\(HeaderKeys.Bearer) \(issuingToken.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]
        ) { [weak self] response in
                do {
                    let offersResponse = try response.get()
                    if let zelf = self {
                        completionBlock(.success(
                            zelf.parse(offersResponse: offersResponse, token:                 issuingToken)
                        ))
                    } else {
                        completionBlock(.failure(VCLError(message: "VCL offers parse could not be completed - self is dead")))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
    
    private func parse(offersResponse: Response, token: VCLToken) -> VCLOffers {
        // VCLXVnfProtocolVersion.XVnfProtocolVersion2
        if let payload = offersResponse.payload.toDictionary() {
            return VCLOffers(
                payload: payload,
                all:  (payload[VCLOffers.CodingKeys.KeyOffers] as? [[String: Any]]) ?? [],
                responseCode: offersResponse.code,
                token: token,
                challenge: (payload[VCLOffers.CodingKeys.KeyChallenge] as? String) ?? ""
            )
        } // VCLXVnfProtocolVersion.XVnfProtocolVersion1
        else if let allOffers = offersResponse.payload.toList() as? [[String: Any]] {
            return VCLOffers(
                payload: [:],
                all: allOffers,
                responseCode: offersResponse.code,
                token: token,
                challenge: ""
            )
        } // No offers
        else {
            return VCLOffers(
                payload: [:],
                all: [],
                responseCode: offersResponse.code,
                token: token,
                challenge: ""
            )
        }
    }
}
