//
//  VCLJwtServiceMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL
@testable import VCToken
@testable import VCCrypto

class VCLJwtServiceMock: VCLJwtService {
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        
    }
    
    func sign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        
    }
}
