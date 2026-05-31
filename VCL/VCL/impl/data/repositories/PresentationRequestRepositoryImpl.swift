//
//  PresentationRequestRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class PresentationRequestRepositoryImpl: PresentationRequestRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        completionBlock: @escaping (VCLResult<String>) -> Void
    ) {
        if let endpoint = presentationRequestDescriptor.endpoint {
            networkService.sendRequest(
                endpoint: endpoint,
                contentType: .ApplicationJson,
                method: .GET,
                headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
            ) { response in
                    do {
                        let presentationRequestResponse = try response.get()
                        if let payload = presentationRequestResponse.payload.toDictionary() {
                            completionBlock(.success(
                                payload[VCLPresentationRequest.CodingKeys.KeyPresentationRequest] as? String ?? ""
                            ))
                        } else {
                            completionBlock(.success(String(data: presentationRequestResponse.payload, encoding: .utf8) ?? ""))
                        }
                    } catch {
                        completionBlock(.failure(ErrorTaxonomy.classifyClientRequestFetch(
                            VCLError(error: error),
                            requestUri: presentationRequestDescriptor.deepLink.requestUri,
                            requestKind: ErrorTaxonomy.requestKindPresentation
                        )))
                    }
                }
        } else {
            completionBlock(.failure(ErrorTaxonomy.invalidLink(
                message: "presentationRequestDescriptor.endpoint = null",
                sourceErrorCode: VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint,
                requestUri: presentationRequestDescriptor.deepLink.requestUri,
                requestKind: ErrorTaxonomy.requestKindPresentation
            )))
        }
    }
}
