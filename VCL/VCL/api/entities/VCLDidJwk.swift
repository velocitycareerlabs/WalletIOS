//
//  VCLDidJwk.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken

public class VCLDidJwk {
    public let keyId: String
    public let didJwk: String
    
    public static let DidJwkPrefix = "did:jwk:"
    
    static func generateDidJwk(publicKey: ECPublicJwk) -> String {
        return "\(VCLDidJwk.DidJwkPrefix)\(publicKey.toJsonString().encodeToBase64())"
    }
    
    public init(
        keyId: String,
        didJwk: String
    ) {
        self.keyId = keyId
        self.didJwk = didJwk
    }
}
