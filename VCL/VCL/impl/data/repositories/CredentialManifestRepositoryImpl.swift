//
//  CredentialManifestRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialManifestRepositoryImpl: CredentialManifestRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        completionBlock: @escaping (VCLResult<String>) -> Void
    ) {
        if let endpoint = credentialManifestDescriptor.endpoint {
            networkService.sendRequest(
                endpoint: endpoint,
                contentType: .ApplicationJson,
                method: .GET,
                headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
            ) { response in
                do {
                    let credentialManifestReposnse = try response.get()
                    if let jwtStr = credentialManifestReposnse.payload.toDictionary()?[VCLCredentialManifest.CodingKeys.KeyIssuingRequest] as? String {
                        completionBlock(.success(jwtStr))
                        
                    } else {
                        completionBlock(.failure(ErrorTaxonomy.classifyClientRequestFetch(
                            VCLError(message: "Failed to parse \(String(data: credentialManifestReposnse.payload, encoding: .utf8) ?? "")"),
                            requestUri: credentialManifestDescriptor.deepLink?.requestUri,
                            requestKind: ErrorTaxonomy.requestKindIssuing
                        )))
                    }
                } catch {
                    completionBlock(.failure(ErrorTaxonomy.classifyClientRequestFetch(
                        VCLError(error: error),
                        requestUri: credentialManifestDescriptor.deepLink?.requestUri,
                        requestKind: ErrorTaxonomy.requestKindIssuing
                    )))
                }
            }
        } else {
            completionBlock(.failure(ErrorTaxonomy.invalidLink(
                message: "credentialManifestDescriptor.endpoint = null",
                sourceErrorCode: VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint,
                requestUri: credentialManifestDescriptor.deepLink?.requestUri,
                requestKind: ErrorTaxonomy.requestKindIssuing
            )))
        }
    }
}
