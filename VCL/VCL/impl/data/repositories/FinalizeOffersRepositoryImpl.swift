//
//  FinalizeOffersRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class FinalizeOffersRepositoryImpl: FinalizeOffersRepository {
    
    private let networkService: NetworkService
    private let jwtServiceRepository: JwtServiceRepository
    
    init(
        _ networkService: NetworkService,
        _ jwtServiceRepository: JwtServiceRepository
    ) {
        self.networkService = networkService
        self.jwtServiceRepository = jwtServiceRepository
    }
    
    func finalizeOffers(
        token: VCLToken,
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<[String]>) -> Void
    ) {
        jwtServiceRepository.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                didJwk: finalizeOffersDescriptor.didJwk,
                kid: "\(finalizeOffersDescriptor.didJwk.generateDidJwkBase64())#0",
                iss: finalizeOffersDescriptor.didJwk.generateDidJwkBase64(),
                aud: finalizeOffersDescriptor.issuerId,
                nonce: finalizeOffersDescriptor.challenge
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                self?.networkService.sendRequest(
                    endpoint: finalizeOffersDescriptor.finalizeOffersUri,
                    body: finalizeOffersDescriptor.generateRequestBody(jwt: jwt).toJsonString(),
                    contentType: Request.ContentType.ApplicationJson,
                    method: .POST,
                    headers: [
                        (HeaderKeys.HeaderKeyAuthorization, "\(HeaderKeys.HeaderValuePrefixBearer) \(token.value)"),
                        (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
                    ])
                { result in
                    do {
                        let finalizedOffersResponse = try result.get()
                        self?.handleFinalizedOffersResponse(
                            finalizedOffersResponse: finalizedOffersResponse,
                            completionBlock: completionBlock
                        )
                    } catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func handleFinalizedOffersResponse(
        finalizedOffersResponse: Response,
        completionBlock: @escaping (VCLResult<[String]>) -> Void
    ) {
        if let encodedJwts = finalizedOffersResponse.payload.toList() as? [String] {
            completionBlock(.success(encodedJwts))
        } else {
            completionBlock(
                .failure(VCLError(message: "Failed to parse: \(finalizedOffersResponse.payload)"))
            )
        }
    }
}
