//
//  VCLJwtVerifyServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import CryptoKit
import Foundation
import VCCrypto
import VCToken

final class VCLJwtVerifyServiceLocalImpl: VCLJwtVerifyService {
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        do {
            switch try signatureAlgorithm(jwt: jwt, publicJwk: publicJwk) {
            case .ES256:
                completionBlock(.success(try verifyP256(jwt: jwt, publicJwk: publicJwk)))
            case .SECP256k1:
                completionBlock(.success(try verifySecp256k1(jwt: jwt, publicJwk: publicJwk)))
            }
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }

    /// Chooses the verifier from the JWK `crv` and requires the JWT `alg` that belongs to it:
    /// P-256 with ES256, secp256k1 with ES256K.
    private func signatureAlgorithm(jwt: VCLJwt, publicJwk: VCLPublicJwk) throws -> VCLSignatureAlgorithm {
        guard let signatureAlgorithm = VCLSignatureAlgorithm(rawValue: publicJwk.curve) else {
            throw VCLError(message: "Unsupported JWK curve: \(publicJwk.curve)")
        }
        let jwsAlgorithm = jwt.header?[VCLJwt.CodingKeys.KeyAlg] as? String ?? ""
        guard jwsAlgorithm == signatureAlgorithm.jwsAlgorithm else {
            throw VCLError(message: "JWT alg \(jwsAlgorithm) does not match JWK crv \(publicJwk.curve)")
        }
        return signatureAlgorithm
    }

    private func verifyP256(jwt: VCLJwt, publicJwk: VCLPublicJwk) throws -> Bool {
        let jwtParts = jwt.encodedJwt.split(separator: ".", omittingEmptySubsequences: false)
        guard jwtParts.count == 3, let signature = Data(base64URLEncoded: String(jwtParts[2])) else {
            throw VCLError(message: "Malformed ES256 JWT")
        }
        let publicKey = try P256.Signing.PublicKey(x963Representation: try p256X963Representation(publicJwk))
        return publicKey.isValidSignature(
            try P256.Signing.ECDSASignature(rawRepresentation: signature),
            for: Data("\(jwtParts[0]).\(jwtParts[1])".utf8)
        )
    }

    /// Uncompressed SEC1 point: 0x04 || x || y.
    private func p256X963Representation(_ publicJwk: VCLPublicJwk) throws -> Data {
        guard
            let x = (publicJwk.valueDict[VCLJwt.CodingKeys.KeyX] as? String).flatMap({ Data(base64URLEncoded: $0) }),
            let y = (publicJwk.valueDict[VCLJwt.CodingKeys.KeyY] as? String).flatMap({ Data(base64URLEncoded: $0) }),
            x.count == 32,
            y.count == 32
        else {
            throw VCLError(message: "Invalid P-256 JWK coordinates")
        }
        return Data([0x04]) + x + y
    }

    private func verifySecp256k1(jwt: VCLJwt, publicJwk: VCLPublicJwk) throws -> Bool {
        let pubKey = ECPublicJwk(
            x: publicJwk.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
            y: publicJwk.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
            keyId: publicJwk.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? ""
        )
        return try jwt.jwsToken?.verify(using: TokenVerifier(), withPublicKey: pubKey) == true
    }
}
