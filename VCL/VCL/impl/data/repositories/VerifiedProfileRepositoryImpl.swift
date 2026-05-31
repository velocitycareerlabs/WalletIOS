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
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: Urls.VerifiedProfile.replacingOccurrences(of: Params.Did, with: verifiedProfileDescriptor.did),
            method: .GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            cachePolicy: .useProtocolCachePolicy
        ) { verifiedProfileResult in
                do {
                    let response = try verifiedProfileResult.get()
                    if let verifiedProfileDict = response.payload.toDictionary(), !verifiedProfileDict.isEmpty {
                        completionBlock(VCLResult.success(VCLVerifiedProfile(payload: verifiedProfileDict)))
                    } else {
                        completionBlock(VCLResult.failure(VCLError(
                            message: "Failed to parse verified profile payload.",
                            statusCode: response.code
                        )))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
}
