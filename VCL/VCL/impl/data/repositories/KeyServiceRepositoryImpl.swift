//
//  KeyServiceRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class KeyServiceRepositoryImpl: KeyServiceRepository {
    
    private let keyService: KeyService
    
    init(_ keyService: KeyService) {
        self.keyService = keyService
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        do {
            completionBlock(.success(try keyService.generateDidJwk()))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
