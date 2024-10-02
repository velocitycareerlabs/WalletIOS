//
//  VCLJwtVerifyServiceMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class VCLJwtVerifyServiceMock: VCLJwtVerifyService {
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    ) {
        completionBlock(.success(true))
    }
}
