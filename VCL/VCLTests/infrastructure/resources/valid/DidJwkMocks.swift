//
//  DidJwkMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 07/02/2024.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class DidJwkMocks {
    static let DidJwk = VCLDidJwk(
        did: "did:jwk:eyJrdHkiOiJFQyIsInVzZSI6InNpZyIsImNydiI6InNlY3AyNTZrMSIsImtpZCI6IjNkODdhZGFmLWQ0ZmEtNDBkZS1iNGYzLTExNGFhOGZmOTMyOCIsIngiOiJvZThGN1ZPWmtOZGpnUTNLdHVmenlwRjBkTWh2QjZVanpYQVRVQ1d2NlRjIiwieSI6IjRQNFZJRFJtYWM2ZlJFY0hkR2tDdVRqdDJMSnNoYVZ2WWpjMGVVZEdpaHcifQ",
        publicJwk: VCLPublicJwk(valueStr: "{\"kty\":\"EC\",\"use\":\"sig\",\"crv\":\"secp256k1\",\"kid\":\"3d87adaf-d4fa-40de-b4f3-114aa8ff9328\",\"x\":\"oe8F7VOZkNdjgQ3KtufzypF0dMhvB6UjzXATUCWv6Tc\",\"y\":\"4P4VIDRmac6fREcHdGkCuTjt2LJshaVvYjc0eUdGihw\"}"),
        kid: "did:jwk:eyJrdHkiOiJFQyIsInVzZSI6InNpZyIsImNydiI6InNlY3AyNTZrMSIsImtpZCI6IjNkODdhZGFmLWQ0ZmEtNDBkZS1iNGYzLTExNGFhOGZmOTMyOCIsIngiOiJvZThGN1ZPWmtOZGpnUTNLdHVmenlwRjBkTWh2QjZVanpYQVRVQ1d2NlRjIiwieSI6IjRQNFZJRFJtYWM2ZlJFY0hkR2tDdVRqdDJMSnNoYVZ2WWpjMGVVZEdpaHcifQ#0",
        keyId: "3d87adaf-d4fa-40de-b4f3-114aa8ff9328"
    )
}
