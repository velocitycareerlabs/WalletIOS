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
        completionBlock(.failure(VCLError(payload: "not implemented for remote")))
    }
    
    func generateSecret(
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "not implemented for remote")))
    }
    
    func retrieveSecretReference(
        keyId: String,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "not implemented for remote")))
    }
    
    func retrievePublicJwk(
        secret: VCCrypto.VCCryptoSecret,
        completionBlock: @escaping (VCLResult<VCToken.ECPublicJwk>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "not implemented for remote")))
    }
}
