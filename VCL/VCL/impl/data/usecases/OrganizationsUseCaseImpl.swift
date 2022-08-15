//
//  OrganizationsUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 07/05/2021.
//

import Foundation

class OrganizationsUseCaseImpl: OrganizationsUseCase {
    
    private let organizationsRepository: OrganizationsRepository
    private let executor: Executor
    
    init(_ organizationsRepository: OrganizationsRepository, _ executor: Executor) {
        self.organizationsRepository = organizationsRepository
        self.executor = executor
    }
    
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void) {
        executor.runOnBackgroundThread() {
            self.organizationsRepository.searchForOrganizations(organizationsSearchDescriptor: organizationsSearchDescriptor) {
                [weak self] organizations in
                self?.executor.runOnMainThread { completionBlock(organizations) }
            }
        }
    }
}
