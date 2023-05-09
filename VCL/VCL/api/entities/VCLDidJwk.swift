//
//  VCLDidJwk.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import Foundation
import VCToken
import VCCrypto

public class VCLDidJwk {
    public let publicKey: ECPublicJwk
    public let privateKey: VCCryptoSecret
    
    public let kid: String
    public let didJwk: String
    
    public static let DidJwkPrefix = "did:jwk:"
    
    public init(
        kid: String,
        publicKey: ECPublicJwk,
        privateKey: VCCryptoSecret
    ) {
        self.kid = kid
        self.publicKey = publicKey
        self.privateKey = privateKey
        self.didJwk = "\(VCLDidJwk.DidJwkPrefix)\(self.publicKey.toJsonString().encodeToBase64())"
    }
}
