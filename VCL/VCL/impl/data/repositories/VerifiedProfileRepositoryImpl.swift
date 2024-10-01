//
//  VerifiedProfileRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class VerifiedProfileRepositoryImpl: VerifiedProfileRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService){
        self.networkService = networkService
    }
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping @Sendable (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.VerifiedProfile.replacingOccurrences(of: Params.Did, with: verifiedProfileDescriptor.did),
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            cachePolicy: .useProtocolCachePolicy
        ) { verifiedProfileResult in
                do {
                    if let verifiedProfileDict = try verifiedProfileResult.get().payload.toDictionary() {
                        completionBlock(VCLResult.success(VCLVerifiedProfile(payload: verifiedProfileDict)))
                    } else {
                        completionBlock(VCLResult.failure(VCLError(message: "Failed to parse verified profile payload.")))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
}
