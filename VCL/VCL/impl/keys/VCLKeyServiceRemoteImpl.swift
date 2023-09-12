//
//  VCLKeyServiceRemoteImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 08/06/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class VCLKeyServiceRemoteImpl: VCLKeyService {
    
    private let networkService: NetworkService
    private let keyServiceUrls: VCLKeyServiceUrls
    
    init(_ networkService: NetworkService, _ keyServiceUrls: VCLKeyServiceUrls) {
        self.networkService = networkService
        self.keyServiceUrls = keyServiceUrls
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )  {
        networkService.sendRequest(
            endpoint: keyServiceUrls.createDidKeyServiceUrl,
            body: generateRequestBody(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { [weak self] isVerifiedJwtResult in
            do {
                if let didKey = try isVerifiedJwtResult.get().payload.toDictionary() {
                    VCLLog.d(didKey.toJsonString() ?? "")
//                        completionBlock(.success(isVerified))
                } else {
                    completionBlock(.failure(VCLError(error: "Failed to parse data from \(self?.keyServiceUrls.createDidKeyServiceUrl ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generateRequestBody() -> String {
        return [
            CodingKeys.KeyCrv: "secp256k1",
            CodingKeys.KeyDidMethod: "did:jwk"
        ].toJsonString() ?? ""
    }
    
    enum CodingKeys {
        static let KeyCrv = "crv"
        static let KeyDidMethod = "didMethod"
        
        static let KeyDid = "did"
        static let KeyPublicJwk = "publicJwk"
        static let KeyKid = "kid"
        static let KeyKeyId = "keyId"
    }
}
