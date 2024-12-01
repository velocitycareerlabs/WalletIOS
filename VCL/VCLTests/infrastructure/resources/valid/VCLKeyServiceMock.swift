//
//  VCLKeyServiceMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto
@testable import VCL

final class VCLKeyServiceMock: VCLKeyService {
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        completionBlock(.success(VCLDidJwk(did: "", publicJwk: VCLPublicJwk(valueStr: ""), kid: "", keyId: "")))
    }
    
    func generateSecret(
        signatureAlgorithm: VCLSignatureAlgorithm,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
    }
    
    func retrieveSecretReference(
        keyId: String,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
    }
    
    func retrievePublicJwk(
        secret: VCCrypto.VCCryptoSecret,
        completionBlock: @escaping (VCLResult<VCToken.ECPublicJwk>) -> Void
    ) {
    }
    
}
