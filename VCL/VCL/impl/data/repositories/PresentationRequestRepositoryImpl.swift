//
//  PresentationRequestRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//

import Foundation

class PresentationRequestRepositoryImpl: PresentationRequestRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func getPresentationRequest(
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<String>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: deepLink.requestUri,
            contentType: .ApplicationJson,
            method: .GET) { response in
            do {
                let presentationRequestResponse = try response.get()
                if let encodedJwtStr = presentationRequestResponse.payload.toDictionary()?[VCLPresentationRequest.CodingKeys.KeyPresentationRequest] as? String {
                    completionBlock(.success(encodedJwtStr))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: presentationRequestResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}

