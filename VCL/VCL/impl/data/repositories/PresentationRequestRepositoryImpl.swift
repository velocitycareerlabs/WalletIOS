//
//  PresentationRequestRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class PresentationRequestRepositoryImpl: PresentationRequestRepository {
    
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
                method: .GET) { response in
                    do {
                        let presentationRequestResponse = try response.get()
                        if let encodedJwtStr = presentationRequestResponse.payload.toDictionary()?[VCLPresentationRequest.CodingKeys.KeyPresentationRequest] as? String {
                            completionBlock(.success(encodedJwtStr))
                        } else {
                            completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: presentationRequestResponse.payload, encoding: .utf8) ?? "")")))
                        }
                    } catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                }
        } else {
            completionBlock(.failure(VCLError(description: "credentialManifestDescriptor.endpoint = null")))
        }
    }
}

