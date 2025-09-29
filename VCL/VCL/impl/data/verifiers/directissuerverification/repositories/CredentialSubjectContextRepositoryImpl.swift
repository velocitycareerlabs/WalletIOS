//
//  CredentialSubjectContextRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/09/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

class CredentialSubjectContextRepositoryImpl: CredentialSubjectContextRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getCredentialSubjectContext(
        credentialSubjectContextEndpoint: String,
        completionBlock: @escaping (VCLResult<[String: Any]>) -> Void
    ) {
        self.networkService.sendRequest(
            endpoint: credentialSubjectContextEndpoint,
            method: Request.HttpMethod.GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { result in
                        
            do {
                if let ldContextResponse = try result.get().payload.toDictionary() {
                    completionBlock(VCLResult.success(ldContextResponse))
                } else {
                    let error = VCLError(payload: "Unexpected LD-Context payload for \(credentialSubjectContextEndpoint)")
                    completionBlock(VCLResult.failure(error))
                }
            } catch {
                completionBlock(VCLResult.failure(VCLError(error: error)))
            }
        }
    }
}
