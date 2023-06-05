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
        token: VCLToken,
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: generateOffersDescriptor.checkOffersUri,
            body: generateOffersDescriptor.payload.toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (HeaderKeys.HeaderKeyAuthorization, "\(HeaderKeys.HeaderValuePrefixBearer) \(token.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]) { [weak self] response in
                do {
                    let offersResponse = try response.get()
                    if let zelf = self {
                        completionBlock(.success(
                            zelf.parse(offersResponse: offersResponse, token: token)
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
            if let payload = offersResponse.payload.toDictionary() {
                return VCLOffers(
                    payload: payload,
                    all: (payload[VCLOffers.CodingKeys.KeyOffers] as? [[String: Any]]) ?? [[String: Any]](),
                    responseCode: offersResponse.code,
                    token: token,
                    challenge: (payload[VCLOffers.CodingKeys.KeyChallenge] as? String) ?? ""
                )
            } else {
                return VCLOffers(
                    payload: [String: Any](),
                    all: [[String: Any]](),
                    responseCode: offersResponse.code,
                    token: token,
                    challenge: ""
                )
            }
        }
}
