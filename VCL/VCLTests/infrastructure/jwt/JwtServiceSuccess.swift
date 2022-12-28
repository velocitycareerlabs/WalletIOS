//
//  JwtServiceSuccess.swift
//  
//
//  Created by Michael Avoyan on 04/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class JwtServiceSuccess: JwtService {
    
    let VclJwt: VCLJwt!
    
    init(VclJwt: VCLJwt) {
        self.VclJwt = VclJwt
    }
    
    func decode(
        encodedJwt: String,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        completionBlock(.success(self.VclJwt))
    }
    
    func encode(
        jwt: String,
        completionBlock: @escaping (VCLResult<String>) -> Void
    ) {
    }
    
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        completionBlock(.success(true))
    }
    
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        completionBlock(.success(VCLJwt(header: nil, payload: nil, signature: nil, encodedJwt: JwtServiceMocks.SignedJwt)))
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        completionBlock(.success(VCLDidJwk(value: VCLDidJwk.DidJwkPrefix)))
    }
}
