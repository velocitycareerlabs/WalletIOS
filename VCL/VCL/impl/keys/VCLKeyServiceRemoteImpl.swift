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
            body: generatePayloadToCreateDidJwk(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { [weak self] didJwkResult in
            do {
                if let didJwkJson = try didJwkResult.get().payload.toDictionary() {
                    completionBlock(
                        .success(
                            VCLDidJwk(
                                did: didJwkJson[CodingKeys.KeyDid] as? String ?? "",
                                publicJwk: VCLPublicJwk(valueDict: didJwkJson[CodingKeys.KeyPublicJwk]as? [String: Any] ?? [:]),
                                kid: didJwkJson[CodingKeys.KeyKid] as? String ?? "",
                                keyId: didJwkJson[CodingKeys.KeyKeyId] as? String ?? ""
                            )
                        )
                    )
                } else {
                    completionBlock(
                        .failure(
                            VCLError(payload: "Failed to create did:jwk from the provided URL: \(self?.keyServiceUrls.createDidKeyServiceUrl ?? "")")
                        )
                    )
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generatePayloadToCreateDidJwk() -> String {
        return [
            CodingKeys.KeyCrv: "secp256k1",
        ].toJsonString() ?? ""
    }
    
    public struct CodingKeys {
        public static let KeyCrv = "crv"
        public static let ValueCrv = "secp256k1"

        public static let KeyDid = "did"
        public static let KeyKid = "kid"
        public static let KeyKeyId = "keyId"
        public static let KeyPublicJwk = "publicJwk"
    }
}
