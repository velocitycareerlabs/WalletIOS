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

public struct VCLDidJwk: Sendable {
    /// The did in jwk format encoded to Base64 format -  - the holder did
    public let did: String
    /// The public JWK
    public let publicJwk: VCLPublicJwk
    /// The kid of jwt - did:jwk suffixed with #0
    public let kid: String
    /// The id of private key save in secure enclave
    public let keyId: String
    
    public var curve: String { get { publicJwk.curve } }
    
    public static let DidJwkPrefix = "did:jwk:"
    public static let DidJwkSuffix = "#0"
    
    static func generateDidJwk(publicKey: ECPublicJwk) -> String {
        return "\(VCLDidJwk.DidJwkPrefix)\(publicKey.toDictionary().toJsonString()?.encodeToBase64() ?? "")"
    }
    
    static func generateKidFromDidJwk(publicKey: ECPublicJwk) -> String {
        return "\(VCLDidJwk.generateDidJwk(publicKey: publicKey))\(VCLDidJwk.DidJwkSuffix)"
    }
    
    public init(
        did: String,
        publicJwk: VCLPublicJwk,
        kid: String,
        keyId: String
    ) {
        self.did = did
        self.publicJwk = publicJwk
        self.kid = kid
        self.keyId = keyId
    }
    
    public struct CodingKeys {
        public static let KeyDid = "did"
        public static let KeyKid = "kid"
        public static let KeyKeyId = "keyId"
    }
}
