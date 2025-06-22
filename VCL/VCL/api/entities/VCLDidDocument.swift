//
//  VCLDidDocument.swift
//  VCL
//
//  Created by Michael Avoyan on 04/06/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public struct VCLDidDocument {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    public init(payloadStr: String) {
        self.payload = payloadStr.toDictionary() ?? [:]
    }
    
    var id: String {get { payload[CodingKeys.KeyId] as? String ?? "" } }

    var alsoKnownAs: [String] {
        if let jsonArray = payload[CodingKeys.KeyAlsoKnownAs] as? [Any] {
            return jsonArray.compactMap { $0 as? String }
        } else {
            return []
        }
    }
    
    func getPublicJwk(kid: String) -> VCLPublicJwk? {
        guard let hashIndex = kid.firstIndex(of: "#") else {
            return nil
        }

        let publicJwkId = "#" + kid[kid.index(after: hashIndex)...]

        guard let verificationMethod = payload[CodingKeys.KeyVerificationMethod] as? [Any] else {
            return nil
        }

        let publicJwkPayload = verificationMethod
            .compactMap { $0 as? [String: Any] }
            .first { $0[CodingKeys.KeyId] as? String == publicJwkId }

        if let publicJwk = publicJwkPayload?[CodingKeys.KeyPublicKeyJwk] as? [String: Any] {
            return VCLPublicJwk(valueDict: publicJwk)
        } else {
            return nil
        }
    }

    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyAlsoKnownAs = "alsoKnownAs"
        public static let KeyVerificationMethod = "verificationMethod"
        public static let KeyPublicKeyJwk = "publicKeyJwk"
    }
}
