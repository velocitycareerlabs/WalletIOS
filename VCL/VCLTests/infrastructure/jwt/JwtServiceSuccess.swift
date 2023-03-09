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
@testable import VCToken
@testable import VCCrypto

class JwtServiceSuccess: JwtService {
    
    let VclJwt: VCLJwt!
    let VclDidJwk: VCLDidJwk!
    
    init(
        VclJwt: VCLJwt,
        VclDidJwk: VCLDidJwk
    ) {
        self.VclJwt = VclJwt
        self.VclDidJwk = VclDidJwk
    }
    
    func decode(encodedJwt: String) -> VCLJwt {
        return self.VclJwt
    }
    
    func encode(jwt: String) -> VCLJwt {
        return self.VclJwt
    }
    
    func verify(jwt: VCLJwt, jwkPublic: VCLJwkPublic) -> Bool {
        return true
    }
    
    func sign(jwtDescriptor: VCLJwtDescriptor) -> VCLJwt {
        return VCLJwt(header: nil, payload: nil, signature: nil, encodedJwt: JwtServiceMocks.SignedJwt)
    }
    
    func generateDidJwk(jwkDescriptor: VCLDidJwkDescriptor) -> VCLDidJwk {
        return self.VclDidJwk
    }
}
