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
import VCCrypto

public class VCLDidJwk {
    public let publicKey: ECPublicJwk
    public let privateKey: VCCryptoSecret
    
    public var publicKeyStr: String { get {  serializePublicKeyToJsonString() } }
    
    public static let DidJwkPrefix = "did:jwk:"
    
    public init(
        publicKey: ECPublicJwk,
        privateKey: VCCryptoSecret
    ) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    public func generateDidJwkBase64() -> String {
        return "\(VCLDidJwk.DidJwkPrefix)\(publicKey.toJson().encodeToBase64())"
    }
    
    private func serializePublicKeyToJsonString() -> String {
        do {
            return try publicKey.serializeToJson().toJsonString() ?? ""
        } catch {
            VCLLog.e(VCLError(error: error))
        }
        return ""
    }
}
