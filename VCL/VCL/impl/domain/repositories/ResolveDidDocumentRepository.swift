//
//  ResolveDidDocumentRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 04/06/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol ResolveDidDocumentRepository {
    func resolveDidDocument(
        did: String,
        completionBlock: @escaping (VCLResult<VCLDidDocument>) -> Void
    )
}
