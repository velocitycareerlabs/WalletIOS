//
//  ExchangeProgressRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExchangeProgressRepositoryImpl: ExchangeProgressRepository {

    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getExchangeProgress(exchangeDescriptor: VCLExchangeDescriptor,
                             completionBlock: @escaping (VCLResult<VCLExchange>) -> Void) {
        networkService.sendRequest(
            endpoint: exchangeDescriptor.processUri +
                "?\(VCLExchangeDescriptor.CodingKeys.KeyExchangeId)=\(exchangeDescriptor.exchangeId ?? "")",
            contentType: Request.ContentType.ApplicationJson,
            method: Request.HttpMethod.GET,
            headers:[
                (HeaderKeys.HeaderKeyAuthorization, "\(HeaderKeys.HeaderValuePrefixBearer) \(exchangeDescriptor.token.value)"),
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
            ]
        ) { [weak self] response in
            do {
                let exchangeProgressResponse = try response.get()
                if let exchange = self?.parseExchange(exchangeProgressResponse.payload.toDictionary()) {
                    completionBlock(.success(exchange))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: exchangeProgressResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }

    private func parseExchange(_ exchangeJsonDict: [String: Any]?) -> VCLExchange {
        return VCLExchange(
            id: exchangeJsonDict?[VCLExchange.CodingKeys.KeyId] as? String,
            type: exchangeJsonDict?[VCLExchange.CodingKeys.KeyType] as? String,
            disclosureComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyDisclosureComplete] as? Bool,
            exchangeComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyExchangeComplete] as? Bool
        )
    }
}
