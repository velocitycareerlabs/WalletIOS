//
//  AuthTokenUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 16/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol AuthTokenUseCase {
    func getAuthToken(
        authTokenDescriptor: VCLAuthTokenDescriptor,
        completionBlock: @escaping (VCLResult<VCLAuthToken>) -> Void
    )
}
