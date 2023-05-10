//
//  JwtService.swift
//  
//
//  Created by Michael Avoyan on 28/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtService {
    func decode(encodedJwt: String) -> VCLJwt
    
    func encode(jwt: String) -> VCLJwt
    
    func verify(jwt: VCLJwt, jwkPublic: VCLJwkPublic) throws -> Bool
    
    func sign(jwtDescriptor: VCLJwtDescriptor) throws -> VCLJwt
    
    func generateDidJwk() throws -> VCLDidJwk
}
