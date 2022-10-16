//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 08/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class JwtServiceRepositoryImpl: JwtServiceRepository {
    
    private let jwtService: JwtService
    
    init(_ jwtService: JwtService) {
        self.jwtService = jwtService
    }
    
    func decode(encodedJwt: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        jwtService.decode(encodedJwt: encodedJwt) { decodedJwtResult in
            do {
                let jwt = try decodedJwtResult.get()
                completionBlock(.success(jwt))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }

    func verifyJwt(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void) {
        jwtService.verify(jwt: jwt, publicKey: publicKey) { signedJwtResult in
            do {
                let isVerified = try signedJwtResult.get()
                completionBlock(.success(isVerified))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    func generateSignedJwt(payload: [String: Any], iss: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        jwtService.sign(payload: payload, iss: iss) { signedJwtResult in
            do {
                let jwt = try signedJwtResult.get()
                completionBlock(.success(jwt))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
