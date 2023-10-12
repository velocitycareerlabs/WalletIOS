//
//  VCLJwtVerifyServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken

class VCLJwtVerifyServiceLocalImpl: VCLJwtVerifyService {
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        do {
            let pubKey = ECPublicJwk(
                x: publicJwk.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
                y: publicJwk.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
                keyId: publicJwk.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? ""
            )
            completionBlock(.success(try jwt.jwsToken?.verify(using: TokenVerifier(), withPublicKey: pubKey) == true))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
