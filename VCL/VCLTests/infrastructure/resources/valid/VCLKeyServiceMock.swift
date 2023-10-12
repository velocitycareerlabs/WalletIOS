//
//  VCLKeyServiceMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL
@testable import VCToken
@testable import VCCrypto

class VCLKeyServiceMock: VCLKeyService {
    func generateDidJwk(
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        completionBlock(.success(VCLDidJwk(did: "", publicJwk: VCLPublicJwk(valueStr: ""), kid: "", keyId: "")))
    }
    
    func generateSecret(completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void) {
    }
    
    func retrieveSecretReference(keyId: String, completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void) {
    }
    
    func retrievePublicJwk(secret: VCCrypto.VCCryptoSecret, completionBlock: @escaping (VCLResult<VCToken.ECPublicJwk>) -> Void) {
    }
    
}
