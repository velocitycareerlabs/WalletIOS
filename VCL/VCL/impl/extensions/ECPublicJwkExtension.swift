//
//  ECPublicJwkExtension.swift
//  VCL
//
//  Created by Michael Avoyan on 19/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken

extension ECPublicJwk {
    func toDictionary() -> [String: String] {
        return [
            CodingKeys.KeyType: self.keyType ?? "",
            CodingKeys.KeyKeyId: self.keyId ?? "",
            CodingKeys.KeyCurve: self.curve ?? "",
            CodingKeys.KeyUse: self.use ?? "",
            CodingKeys.KeyX: self.x ?? "",
            CodingKeys.KeyY: self.y ?? ""
        ]
    }
    struct CodingKeys {
        static let KeyType = "kty"
        static let KeyKeyId = "kid"
        static let KeyCurve = "crv"
        static let KeyUse = "use"
        static let KeyX = "x"
        static let KeyY = "y"
    }
}
