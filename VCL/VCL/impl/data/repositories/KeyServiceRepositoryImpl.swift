//
//  KeyServiceRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class KeyServiceRepositoryImpl: KeyServiceRepository {
    
    private let keyService: VCLKeyService
    
    init(_ keyService: VCLKeyService) {
        self.keyService = keyService
    }
    
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        keyService.generateDidJwk(
            didJwkDescriptor: didJwkDescriptor,
            completionBlock: completionBlock
        )
    }
}
