//
//  JwtServiceRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 07/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtServiceRepository {
    func decode(encodedJwt: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void)
    func verifyJwt(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void)
    func generateSignedJwt(payload: [String: Any], iss: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void)
}
