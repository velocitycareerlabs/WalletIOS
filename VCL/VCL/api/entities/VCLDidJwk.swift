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
    /// The id of private key save in secure enclave
    public let keyId: String
    /// The did:jwk
    public let value: String
    /// kid of jwt - did:jwk suffixed with #0
    public let kid: String
    
    func toPublicJwkStr() -> String? {
        value.removePrefix(VCLDidJwk.DidJwkPrefix).decodeBase64()
    }
    
    public static let DidJwkPrefix = "did:jwk:"
    public static let DidJwkSuffix = "#0"
    
    static func generateDidJwk(publicKey: ECPublicJwk) -> String {
        return "\(VCLDidJwk.DidJwkPrefix)\(publicKey.toDictionary().toJsonString()?.encodeToBase64() ?? "")"
    }
    
    static func generateKidFromDidJwk(publicKey: ECPublicJwk) -> String {
        return "\(VCLDidJwk.generateDidJwk(publicKey: publicKey))\(VCLDidJwk.DidJwkSuffix)"
    }
    
    public init(
        keyId: String,
        value: String,
        kid: String
    ) {
        self.keyId = keyId
        self.value = value
        self.kid = kid
    }
    
    public struct CodingKeys {
        public static let KeyKeyId = "keyId"
        public static let KeyValue = "value"
        public static let KeyKid = "kid"
    }
    
    public func toString() -> String? {
        return [
            CodingKeys.KeyKeyId: keyId,
            CodingKeys.KeyValue: value,
            CodingKeys.KeyKid: kid
        ].toJsonString()
    }
}
