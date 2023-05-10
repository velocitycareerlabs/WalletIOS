//
//  ECPublicJwkExtensions.swift
//  VCL
//
//  Created by Michael Avoyan on 08/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken

extension ECPublicJwk {

//    Although ECPublicJwk is Codable, we must use the manual serialization in order to keep the order
    func toDictionary() -> [String: Any?] {
        return [
            CodingKeys.KeyKid: self.keyId,
            CodingKeys.KeyKty: self.keyType,
            CodingKeys.KeyUse: self.use,
            CodingKeys.KeyCrv: self.curve,
            CodingKeys.KeyAlgorithm: self.algorithm,
            CodingKeys.KeyOperations: self.keyOperations,
            CodingKeys.KeyX: self.x,
            CodingKeys.KeyY: self.y,
        ]
    }
    
    func toJsonString() -> String {
        return "\"\(CodingKeys.KeyKid)\":\"\(self.keyId ?? "")\",\"\(CodingKeys.KeyKty)\":\"\(self.keyType)\",\"\(CodingKeys.KeyUse)\":\"\(self.use ?? "")\",\"\(CodingKeys.KeyCrv)\":\"\(self.curve)\",\"\(CodingKeys.KeyAlgorithm)\":\"\(self.algorithm ?? "")\",\"\(CodingKeys.KeyOperations)\":\"\(self.keyOperations ?? [String]())\",\"\(CodingKeys.KeyX)\":\"\(self.x)\",\"\(CodingKeys.KeyY)\":\"\(self.y ?? "")\""
//        return self.toDictionary().toJsonString() ?? ""
    }

    enum CodingKeys {        
        static let KeyKid = "kid"
        static let KeyKty = "kty"
        static let KeyUse = "use"
        static let KeyCrv = "crv"
        static let KeyAlgorithm = "alg"
        static let KeyOperations = "key_ops"
        static let KeyX = "x"
        static let KeyY = "y"
    }
}
