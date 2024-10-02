//
//  VerifiedProfileRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol VerifiedProfileRepository: Sendable {
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping @Sendable (VCLResult<VCLVerifiedProfile>) -> Void
    )
}
