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
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderKValues.XVnfProtocolVersion)],
            cachePolicy: .useProtocolCachePolicy
        ) {
                [weak self] publicKeyResponse in
                do {
                    let verifiedProfileResponse = try publicKeyResponse.get()
                    if let verifiedProfileDict = verifiedProfileResponse.payload.toDictionary() {
                        self?.verifyServiceType(
                            verifiedProfileDict: verifiedProfileDict,
                            expectedServiceType: verifiedProfileDescriptor.serviceType,
                            completionBlock: completionBlock)
                        
                    } else {
                        completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: verifiedProfileResponse.payload, encoding: .utf8) ?? "")")))
                    }
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
    }
    
    private func verifyServiceType(
        verifiedProfileDict: [String: Any],
        expectedServiceType: VCLServiceType?,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        let verifiedProfile: VCLVerifiedProfile = VCLVerifiedProfile(payload: verifiedProfileDict)
        if let expectedServiceType = expectedServiceType {
            if (verifiedProfile.serviceTypes.contains(serviceType: expectedServiceType)) {
                completionBlock(VCLResult.success(verifiedProfile))
            }
            else {
                completionBlock(VCLResult.failure(VCLError(
                    description: "Wrong service type - expected: \(expectedServiceType.rawValue), found: \(verifiedProfile.serviceTypes.all)",
                    code: VCLErrorCode.VerificationError.rawValue
                )))
            }
        } else {
            completionBlock(VCLResult.success(verifiedProfile))
        }
    }
}
