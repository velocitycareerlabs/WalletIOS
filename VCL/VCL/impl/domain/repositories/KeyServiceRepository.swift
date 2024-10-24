//
//  KeyServiceRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol KeyServiceRepository: Sendable {
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping @Sendable (VCLResult<VCLDidJwk>) -> Void
    )
}
