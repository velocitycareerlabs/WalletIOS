//
//  VCLJwt.swift
//
//
//  Created by Michael Avoyan on 26/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@preconcurrency import VCToken

public struct VCLJwt {
    public private(set) var header: [String: Any]? = nil
    public private(set) var payload: [String: Any]? = nil
    public private(set) var signature: String? = nil
    public private(set) var encodedJwt: String = ""

    public private(set) var jwsToken: JwsToken<VCLClaims>? = nil

    public init(
        header: [String: Any]?,
        payload: [String: Any]?,
        signature: String?,
        encodedJwt: String
    ) {
        initialize(header: header, payload: payload, signature: signature, encodedJwt: encodedJwt)
    }

    public init(encodedJwt: String) throws {
        let jwtParts = encodedJwt.split(separator: ".", omittingEmptySubsequences: false).map { String($0) }
        guard jwtParts.count == 3 else {
            throw VCLError(message: "JWT must contain header, payload, and signature")
        }
        guard !jwtParts[0].isEmpty, let headerJson = jwtParts[0].decodeBase64URL(), let header = headerJson.toDictionary() else {
            throw VCLError(message: "Failed to decode JWT header")
        }
        guard !jwtParts[1].isEmpty, let payloadJson = jwtParts[1].decodeBase64URL(), let payload = payloadJson.toDictionary() else {
            throw VCLError(message: "Failed to decode JWT payload")
        }
        guard !jwtParts[2].isEmpty else {
            throw VCLError(message: "JWT signature is missing")
        }
        initialize(
            header: header,
            payload: payload,
            signature: jwtParts[2],
            encodedJwt: encodedJwt
        )
    }

    public init(validatedEncodedJwt encodedJwt: String) throws {
        try self.init(encodedJwt: encodedJwt)
    }

    private mutating func initialize(
        header: [String: Any]? = nil,
        payload: [String: Any]? = nil,
        signature: String? = nil,
        encodedJwt: String
    ) {
        self.header = header
        self.payload = payload
        self.signature = signature
        self.encodedJwt = encodedJwt

        self.jwsToken = JwsToken<VCLClaims>(from: encodedJwt)
    }

    public struct CodingKeys {
        public static let KeyTyp = "typ"
        public static let KeyAlg = "alg"
        public static let KeyKid = "kid"
        public static let KeyJwk = "jwk"

        public static let KeyX = "x"
        public static let KeyY = "y"

        public static let KeyHeader = "header"
        public static let KeyPayload = "payload"
        public static let KeySignature = "signature"

        public static let KeyIss = "iss"
        public static let KeyAud = "aud"
        public static let KeySub = "sub"
        public static let KeyJti = "jti"
        public static let KeyIat = "iat"
        public static let KeyNbf = "nbf"
        public static let KeyExp = "exp"
        public static let KeyNonce = "nonce"
    }

    var kid: String? { get {
        return (header?[CodingKeys.KeyKid] as? String) ?? ((header?[CodingKeys.KeyJwk] as? [String: Any])?[CodingKeys.KeyKid]) as? String
    } }
    var iss: String? { get {
        return self.payload?[CodingKeys.KeyIss] as? String
    } }
    var aud: String? { get {
        return self.payload?[CodingKeys.KeyAud] as? String
    } }
    var sub: String? { get {
        return self.payload?[CodingKeys.KeySub] as? String
    } }
    var jti: String? { get {
        return self.payload?[CodingKeys.KeyJti] as? String
    } }
    var iat: String? { get {
        return self.payload?[CodingKeys.KeyIat] as? String
    } }
    var nbf: Double? { get {
        return self.payload?[CodingKeys.KeyNbf] as? Double
    } }
    var exp: Double? { get {
        return self.payload?[CodingKeys.KeyExp] as? Double
    } }
    var nonce: String? { get {
        return self.payload?[CodingKeys.KeyNonce] as? String
    } }
}
