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
    
    func decode(
        encodedJwt: String,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        jwtService.decode(encodedJwt: encodedJwt) { decodedJwtResult in
            do {
                completionBlock(.success(try decodedJwtResult.get()))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }

    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        jwtService.verify(jwt: jwt, jwkPublic: jwkPublic) { isVerifiedResult in
            do {
                completionBlock(.success(try isVerifiedResult.get()))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        jwtService.sign(jwtDescriptor: jwtDescriptor) { signedJwtResult in
            do {
                completionBlock(.success(try signedJwtResult.get()))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        jwtService.generateDidJwk { didJwkResult in
            do {
                completionBlock(.success(try didJwkResult.get()))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
}
