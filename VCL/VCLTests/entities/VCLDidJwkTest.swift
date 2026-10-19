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
