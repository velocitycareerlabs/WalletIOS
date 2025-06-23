//
//  ResolveDidDocumentRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 04/06/2025.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class ResolveDidDocumentRepositoryImpl: ResolveDidDocumentRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func resolveDidDocument(
        did: String,
        completionBlock: @escaping (VCLResult<VCLDidDocument>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.ResolveDid + did,
            contentType: Request.ContentType.ApplicationJson,
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) {
            response in
            do{
                let didDocumentResponse = try response.get()
                if let didDocumentPayload = didDocumentResponse.payload.toDictionary() {
                    completionBlock(.success(VCLDidDocument(payload: didDocumentPayload)))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: didDocumentResponse.payload, encoding: .utf8) ?? "")")))
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
