//
//  VerifiedProfileRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class VerifiedProfileRepositoryImpl: VerifiedProfileRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService){
        self.networkService = networkService
    }
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.VerifiedProfile.replacingOccurrences(of: Params.Did, with: verifiedProfileDescriptor.did),
            method: Request.HttpMethod.GET,
            cachePolicy: .useProtocolCachePolicy) {
                publicKeyResponse in
                do {
                    let verifiedProfileResponse = try publicKeyResponse.get()
                    if let verifiedProfileDict = verifiedProfileResponse.payload.toDictionary() {
                        completionBlock(.success(VCLVerifiedProfile(payload: verifiedProfileDict)))
                    } else {
                        completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: verifiedProfileResponse.payload, encoding: .utf8) ?? "")")))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
    
    
}
