//
//  VCLDidJwkTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
import VCToken
@testable import VCL

final class VCLDidJwkTest: XCTestCase {

    /// Runs of "~" and "?" make standard base64 emit "+" and "/" whatever the JSON key order is.
    private let publicKey = ECPublicJwk(
        x: "oe8F7VOZkNdjgQ3KtufzypF0dMhvB6UjzXATUCWv6Tc",
        y: "4P4VIDRmac6fREcHdGkCuTjt2LJshaVvYjc0eUdGihw",
        keyId: "~~~???"
    )

    /// `publicKey` serialized as canonical JSON (sorted keys). The 157 bytes need "==" padding in standard base64,
    /// and the kid makes standard base64 emit "+" and "/".
    private let crossSdkJwkJson =
        "{\"crv\":\"secp256k1\",\"kid\":\"~~~???\",\"kty\":\"EC\",\"use\":\"sig\"," +
        "\"x\":\"oe8F7VOZkNdjgQ3KtufzypF0dMhvB6UjzXATUCWv6Tc\",\"y\":\"4P4VIDRmac6fREcHdGkCuTjt2LJshaVvYjc0eUdGihw\"}"

    /// Produced outside this SDK, and identical from both sources:
    /// - `@verii/did-doc` 1.3.0-pre.1792474660.0 (LFDT-Verii/core 2ed15d93) `getDidUriFromJwk` for the JWK above.
    /// - WalletAndroid 09a6404 `VCLDidJwk.DidJwkPrefix` + `String.encodeToBase64URL()` (nimbus-jose-jwt 10.5) on `crossSdkJwkJson`.
    private let crossSdkDidJwk =
        "did:jwk:eyJjcnYiOiJzZWNwMjU2azEiLCJraWQiOiJ-fn4_Pz8iLCJrdHkiOiJFQyIsInVzZSI6InNpZyIsIngiOiJvZThGN1ZPWmtOZGpnUTNLdHVmenlwRjBkTWh2" +
        "QjZVanpYQVRVQ1d2NlRjIiwieSI6IjRQNFZJRFJtYWM2ZlJFY0hkR2tDdVRqdDJMSnNoYVZ2WWpjMGVVZEdpaHcifQ"

    func testEncodeToBase64UrlReplacesUnsafeCharactersAndDropsPadding() {
        let json = "{\"kid\":\"~~~???\"}"

        XCTAssertEqual(json.encodeToBase64(), "eyJraWQiOiJ+fn4/Pz8ifQ==")
        XCTAssertEqual(json.encodeToBase64Url(), "eyJraWQiOiJ-fn4_Pz8ifQ")
    }

    func testGenerateDidJwkUsesBase64UrlWithoutPadding() throws {
        let did = VCLDidJwk.generateDidJwk(publicKey: publicKey)

        XCTAssertTrue(did.hasPrefix(VCLDidJwk.DidJwkPrefix))
        let encodedJwk = did.removePrefix(VCLDidJwk.DidJwkPrefix)
        let jwkJson = try XCTUnwrap(encodedJwk.decodeBase64URL())
        let standardBase64 = Data(jwkJson.utf8).base64EncodedString()
        XCTAssertTrue(standardBase64.contains("+"), "fixture must exercise '+': \(standardBase64)")
        XCTAssertTrue(standardBase64.contains("/"), "fixture must exercise '/': \(standardBase64)")

        let expectedBase64Url = standardBase64
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        XCTAssertEqual(encodedJwk, expectedBase64Url)
        XCTAssertNil(encodedJwk.rangeOfCharacter(from: CharacterSet(charactersIn: "+/=")))
        XCTAssertEqual(
            try XCTUnwrap(jwkJson.toDictionary()) as NSDictionary,
            publicKey.toDictionary() as NSDictionary
        )
    }

    /// generateDidJwk(publicKey:) serializes the JWK with a key order that changes between processes,
    /// so the exact cross-SDK string is checked on the JSON-to-did step it delegates to.
    func testGenerateDidJwkMatchesCrossSdkFixture() throws {
        XCTAssertEqual(
            try XCTUnwrap(crossSdkJwkJson.toDictionary()) as NSDictionary,
            publicKey.toDictionary() as NSDictionary
        )
        XCTAssertEqual(VCLDidJwk.generateDidJwk(jwkJson: crossSdkJwkJson), crossSdkDidJwk)
    }

    func testToPublicJwkDecodesCrossSdkFixture() {
        XCTAssertEqual(crossSdkDidJwk.toPublicJwk().valueDict as NSDictionary, publicKey.toDictionary() as NSDictionary)
    }

    func testGenerateKidFromDidJwkAppendsFragmentToBase64UrlDid() throws {
        let kid = VCLDidJwk.generateKidFromDidJwk(publicKey: publicKey)

        XCTAssertTrue(kid.hasPrefix(VCLDidJwk.DidJwkPrefix))
        XCTAssertTrue(kid.hasSuffix(VCLDidJwk.DidJwkSuffix))
        let encodedJwk = String(
            kid.removePrefix(VCLDidJwk.DidJwkPrefix).dropLast(VCLDidJwk.DidJwkSuffix.count)
        )
        XCTAssertNil(encodedJwk.rangeOfCharacter(from: CharacterSet(charactersIn: "+/=")))
        XCTAssertEqual(
            try XCTUnwrap(encodedJwk.decodeBase64URL()?.toDictionary()) as NSDictionary,
            publicKey.toDictionary() as NSDictionary
        )
    }

    func testToPublicJwkDecodesBase64UrlDidJwk() {
        let did = VCLDidJwk.generateDidJwk(publicKey: publicKey)

        XCTAssertEqual(did.toPublicJwk().valueDict as NSDictionary, publicKey.toDictionary() as NSDictionary)
        XCTAssertEqual(
            "\(did)\(VCLDidJwk.DidJwkSuffix)".toPublicJwk().valueDict as NSDictionary,
            publicKey.toDictionary() as NSDictionary
        )
    }
}
