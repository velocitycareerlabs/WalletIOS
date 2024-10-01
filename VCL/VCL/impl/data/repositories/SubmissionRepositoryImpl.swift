//
//  SubmissionRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class SubmissionRepositoryImpl: SubmissionRepository {
    
    private let networkService: NetworkService
    
    init(
        _ networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func submit(
        submission: VCLSubmission,
        jwt: VCLJwt,
        completionBlock: @escaping @Sendable (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        self.networkService.sendRequest(
            endpoint: submission.submitUri,
            body: submission.generateRequestBody(jwt: jwt).toJsonString(),
            contentType: Request.ContentType.ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            completionBlock: { [weak self] result in
                if let self = self {
                    do {
                        let submissionResponse = try result.get()
                        let jsonDict = submissionResponse.payload.toDictionary()
                        let submissionResult = self.parse(jsonDict, submission.jti, submission.submissionId)
                        completionBlock(.success(submissionResult))
                    }
                    catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                } else {
                    completionBlock(.failure(VCLError(message: "self is nil")))
                }
            })
    }
    
    private func parse(_ jsonDict: [String: Any]?, _ jti: String, _ submissionId: String) -> VCLSubmissionResult {
        let exchangeJsonDict = jsonDict?[VCLSubmissionResult.CodingKeys.KeyExchange]
        return VCLSubmissionResult(
            sessionToken: VCLToken(value: jsonDict?[VCLSubmissionResult.CodingKeys.KeyToken] as? String ?? ""),
            exchange: parseExchange(exchangeJsonDict as? [String : Any]),
            jti: jti,
            submissionId: submissionId
        )
    }
    
    private func parseExchange(_ exchangeJsonDict: [String: Any]?) -> VCLExchange {
        return VCLExchange(
            id: exchangeJsonDict?[VCLExchange.CodingKeys.KeyId] as? String,
            type: exchangeJsonDict?[VCLExchange.CodingKeys.KeyType] as? String,
            disclosureComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyDisclosureComplete] as? Bool,
            exchangeComplete: exchangeJsonDict?[VCLExchange.CodingKeys.KeyExchangeComplete] as? Bool
        )
    }
}
