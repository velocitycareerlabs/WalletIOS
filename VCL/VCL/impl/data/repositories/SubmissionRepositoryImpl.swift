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
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func submit(submission: VCLSubmission,
                jwt: VCLJwt,
                completionBlock: @escaping (VCLResult<VCLPresentationSubmissionResult>) -> Void) {
        networkService.sendRequest(
            endpoint: submission.submitUri,
            body: submission.generateRequestBody(jwt: jwt).toJsonString(),
            contentType: Request.ContentType.ApplicationJson,
            method: Request.HttpMethod.POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderKValues.XVnfProtocolVersion)]
        ) { [weak self] _response in
            do{
                let submissionResponse = try _response.get()
                if let submissionResult =
                    self?.parse(submissionResponse.payload.toDictionary(), submission.jti, submission.submissionId) {
                    completionBlock(.success(submissionResult))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: submissionResponse.payload, encoding: .utf8) ?? "")")))
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(_ jsonDict: [String: Any]?, _ jti: String, _ submissionId: String) -> VCLPresentationSubmissionResult {
        let exchangeJsonDict = jsonDict?[VCLPresentationSubmissionResult.CodingKeys.KeyExchange]
        return VCLPresentationSubmissionResult(
            token: VCLToken(value: jsonDict?[VCLPresentationSubmissionResult.CodingKeys.KeyToken] as? String ?? ""),
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
