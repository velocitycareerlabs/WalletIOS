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
    func toDictionary() -> [String: String?] {
        return [
            CodingKeys.KeyKid: self.keyId,
            CodingKeys.KeyKty: self.keyType,
            CodingKeys.KeyUse: self.use,
            CodingKeys.KeyCrv: self.curve,
            CodingKeys.KeyX: self.x,
            CodingKeys.KeyY: self.y
        ]
    }
    
    func toJson() -> String {
//        return "{\"\(CodingKeys.KeyKid)\":\"\(self.keyId ?? "")\",\"\(CodingKeys.KeyKty)\":\"\(self.keyType)\",\"\(CodingKeys.KeyUse)\":\"\(self.use ?? "")\",\"(CodingKeys.KeyCrv)\":\"\(self.curve)\",\"\(CodingKeys.KeyX)\":\"\(self.x)\",\"\(CodingKeys.KeyY)\":\"\(self.y)\""
        return self.toDictionary().toJsonString() ?? ""
    }
        
    enum CodingKeys {        
        static let KeyKid = "kid"
        static let KeyKty = "kty"
        static let KeyUse = "use"
        static let KeyCrv = "crv"
        static let KeyX = "x"
        static let KeyY = "y"
    }
}
