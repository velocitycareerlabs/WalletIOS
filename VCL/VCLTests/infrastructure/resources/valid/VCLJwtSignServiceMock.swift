//
//  VCLJwtSignServiceMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class VCLJwtSignServiceMock: VCLJwtSignService {
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String?,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    ) {
        completionBlock(.success(VCLJwt(encodedJwt: "")))
    }
}
