//
//  ResolveKidRepository.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol ResolveKidRepository {
    func getPublicKey(
        kid: String,
        completionBlock: @escaping (VCLResult<VCLPublicJwk>) -> Void
    )
}
