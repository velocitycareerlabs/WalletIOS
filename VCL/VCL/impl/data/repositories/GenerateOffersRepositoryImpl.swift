//
//  GenerateOffersRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//

import Foundation

class GenerateOffersRepositoryImpl: GenerateOffersRepository {
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func generateOffers(token: VCLToken,
                        generateOffersDescriptor: VCLGenerateOffersDescriptor,
                        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void) {
        networkService.sendRequest(
            endpoint: generateOffersDescriptor.checkOffersUri,
            body: generateOffersDescriptor.payload.toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers:[
                (VCLExchangeDescriptor.CodingKeys.HeaderKeyAuthorization,
                 "\(VCLExchangeDescriptor.CodingKeys.HeaderValuePrefixBearer) \(token.value)")
            ]) { [weak self] response in
            do {
                let offersResponse = try response.get()
                if let zelf = self {
                    completionBlock(.success(
                        zelf.parse(offersResponse: offersResponse, token: token)
                    ))
                } else {
                    completionBlock(.failure(VCLError(description: "VCL offers parse could not be completed - self is dead")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(offersResponse: Response, token: VCLToken) -> VCLOffers {
        if let offers = offersResponse.payload.toListOfDictionaries() {
            return VCLOffers(
                all: offers,
                responseCode: offersResponse.code,
                token: token
            )
        } else if let offers = offersResponse.payload.toDictionary() {
            if(offers.isEmpty) {
                return VCLOffers(
                        all: [],
                        responseCode: offersResponse.code,
                        token: token
                    )
            } else {
                return VCLOffers(
                    all: [offers],
                    responseCode: offersResponse.code,
                    token: token
                    )
            }
        } else {
            return VCLOffers(
                    all: [],
                    responseCode: offersResponse.code,
                    token: token
                )
        }
    }
}
