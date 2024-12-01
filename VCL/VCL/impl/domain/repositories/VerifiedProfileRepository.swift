//
//  VerifiedProfileRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol VerifiedProfileRepository {
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    )
}
