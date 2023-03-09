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
        completionBlock(.success(jwtService.decode(encodedJwt: encodedJwt)))
    }
    
    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        do {
            completionBlock(.success(try jwtService.verify(jwt: jwt, jwkPublic: jwkPublic)))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        do {
            completionBlock(.success(try jwtService.sign(jwtDescriptor: jwtDescriptor)))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func generateDidJwk(
        jwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        do {
            completionBlock(.success(try jwtService.generateDidJwk(jwkDescriptor: jwkDescriptor)))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
