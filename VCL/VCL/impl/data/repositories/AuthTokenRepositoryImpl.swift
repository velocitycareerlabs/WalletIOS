//
//  AuthTokenRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/04/2025.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class AuthTokenRepositoryImpl: AuthTokenRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getAuthToken(
        authTokenDescriptor: VCLAuthTokenDescriptor,
        completionBlock: @escaping (VCLResult<VCLAuthToken>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: authTokenDescriptor.authTokenUri,
            body: authTokenDescriptor.generateRequestBody().toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { result in
            do {
                if let payload = try result.get().payload.toDictionary() {
                    completionBlock(
                        VCLResult.success(
                            VCLAuthToken(
                                payload: payload,
                                authTokenUri: authTokenDescriptor.authTokenUri,
                                walletDid: authTokenDescriptor.walletDid,
                                relyingPartyDid: authTokenDescriptor.relyingPartyDid
                            )
                        )
                    )
                } else {
                    completionBlock(
                        VCLResult.failure(
                            VCLError(payload: "Failed to parse auth token response")
                        )
                    )
                }
            } catch {
                completionBlock(VCLResult.failure(VCLError(error: error)))
            }
        }
    }
}
