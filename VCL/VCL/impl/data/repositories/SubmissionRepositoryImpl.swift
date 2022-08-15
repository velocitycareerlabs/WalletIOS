//
//  SubmissionRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//

import Foundation

class SubmissionRepositoryImpl: SubmissionRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func submit(submission: VCLSubmission,
                jwt: VCLJWT,
                completionBlock: @escaping (VCLResult<VCLPresentationSubmissionResult>) -> Void) {
        var body = [String: String]()
        body[VCLPresentationSubmission.CodingKeys.KeyDid] = submission.iss
        body[VCLPresentationSubmission.CodingKeys.KeyExchangeId] = submission.exchangeId
        body[VCLPresentationSubmission.CodingKeys.KeyJwtVp] = jwt.encodedJwt
        networkService.sendRequest(
            endpoint: submission.submitUri,
            body: body.toJsonString(),
            contentType: Request.ContentType.ApplicationJson,
            method: Request.HttpMethod.POST
        ) { [weak self] _response in
            do{
                let submissionResponse = try _response.get()
                if let presentationSubmissionResult = self?.parse(submissionResponse.payload.toDictionary()) {
                    completionBlock(.success(presentationSubmissionResult))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: submissionResponse.payload, encoding: .utf8) ?? "")")))
                }
            }
            catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(_ jsonDict: [String: Any]?) -> VCLPresentationSubmissionResult {
        let exchangeJsonDict = jsonDict?[VCLPresentationSubmissionResult.CodingKeys.KeyExchange]
        return VCLPresentationSubmissionResult(
            token: VCLToken(value: jsonDict?[VCLPresentationSubmissionResult.CodingKeys.KeyToken] as? String ?? ""),
            exchange: parseExchange(exchangeJsonDict as? [String : Any])
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
