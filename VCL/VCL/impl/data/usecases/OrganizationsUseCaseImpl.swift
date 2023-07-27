//
//  OrganizationsUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 07/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class OrganizationsUseCaseImpl: OrganizationsUseCase {
        
    private let organizationsRepository: OrganizationsRepository
    private let executor: Executor
    
    init(
        _ organizationsRepository: OrganizationsRepository,
        _ executor: Executor
    ) {
        self.organizationsRepository = organizationsRepository
        self.executor = executor
    }
    
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void) {
        executor.runOnBackground { [weak self] in
            self?.organizationsRepository.searchForOrganizations(organizationsSearchDescriptor: organizationsSearchDescriptor) {
                organizations in
                self?.executor.runOnMain { completionBlock(organizations) }
            }
        }
    }
}
