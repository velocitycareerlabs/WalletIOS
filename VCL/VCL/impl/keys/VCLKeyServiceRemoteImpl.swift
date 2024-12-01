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

final class VCLKeyServiceRemoteImpl: VCLKeyService {
    
    private let networkService: NetworkService
    private let keyServiceUrls: VCLKeyServiceUrls
    
    init(_ networkService: NetworkService, _ keyServiceUrls: VCLKeyServiceUrls) {
        self.networkService = networkService
        self.keyServiceUrls = keyServiceUrls
    }
    
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor = VCLDidJwkDescriptor(),
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )  {
        networkService.sendRequest(
            endpoint: keyServiceUrls.createDidKeyServiceUrl,
            body: generatePayloadToCreateDidJwk(signatureAlgorithm: didJwkDescriptor.signatureAlgorithm).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion),
                (HeaderKeys.Authorization, "\(HeaderKeys.Bearer) \(didJwkDescriptor.remoteCryptoServicesToken?.value ?? "")")
            ]
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
    
    private func generatePayloadToCreateDidJwk(
        signatureAlgorithm: VCLSignatureAlgorithm
    ) -> [String: Any] {
        return [
            CodingKeys.KeyCrv: signatureAlgorithm.curve,
        ]
    }
    
    public struct CodingKeys {
        public static let KeyCrv = "crv"

        public static let KeyDid = "did"
        public static let KeyKid = "kid"
        public static let KeyKeyId = "keyId"
        public static let KeyPublicJwk = "publicJwk"
    }
}
