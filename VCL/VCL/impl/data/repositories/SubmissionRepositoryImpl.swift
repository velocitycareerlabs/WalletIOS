//
//  SubmissionRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class SubmissionRepositoryImpl: SubmissionRepository {
    
    private let networkService: NetworkService
    private let jwtServiceRepository: JwtServiceRepository
    
    init(
        _ networkService: NetworkService,
        _ jwtServiceRepository: JwtServiceRepository
    ) {
        self.networkService = networkService
        self.jwtServiceRepository = jwtServiceRepository
    }
    
    func submit(
        submission: VCLSubmission,
        jwt: VCLJwt,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        jwtServiceRepository.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                didJwk: submission.didJwk,
                kid: "\(submission.didJwk.generateDidJwkBase64())#0",
                payload: submission.payload,
                jti: submission.jti,
                iss: submission.iss
            )
        ) { [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                if let _self = self {
                    _self.networkService.sendRequest(
                        endpoint: submission.submitUri,
                        body: submission.generateRequestBody(jwt: jwt).toJsonString(),
                        contentType: Request.ContentType.ApplicationJson,
                        method: .POST,
                        headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
                        completionBlock: { result in
                            do {
                                let submissionResponse = try result.get()
                                let jsonDict = submissionResponse.payload.toDictionary()
                                let submissionResult = _self.parse(jsonDict, submission.jti, submission.submissionId)
                                completionBlock(.success(submissionResult))
                            }
                            catch {
                                completionBlock(.failure(VCLError(error: error)))
                            }
                        })
                } else {
                    completionBlock(.failure(VCLError(message: "self is nil")))
                }
            } catch {
                    completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(_ jsonDict: [String: Any]?, _ jti: String, _ submissionId: String) -> VCLSubmissionResult {
        let exchangeJsonDict = jsonDict?[VCLSubmissionResult.CodingKeys.KeyExchange]
        return VCLSubmissionResult(
            token: VCLToken(value: jsonDict?[VCLSubmissionResult.CodingKeys.KeyToken] as? String ?? ""),
            exchange: parseExchange(exchangeJsonDict as? [String : Any]),
            jti: jti,
            submissionId: submissionId
        )
    }
    
    private func parseExchange(_ exchangeJsonDict: [String: Any]?) -> VCLExchange {
        return VCLExchange(id: exchangeJsonDict?[VCLExchange.CodingKeys.KeyId] as? String,
                           type: exchangeJsonDict?[VCLExchange.CodingKeys.KeyType] as? String,
                           disclosureComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyDisclosureComplete] as? Bool,
                           exchangeComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyExchangeComplete] as? Bool
        )
    }
}
