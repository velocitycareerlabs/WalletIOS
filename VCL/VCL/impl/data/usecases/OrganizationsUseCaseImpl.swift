//
//  OrganizationsUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 07/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class OrganizationsUseCaseImpl: OrganizationsUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let organizationsRepository: OrganizationsRepository
    private let executor: Executor
    
    init(_ organizationsRepository: OrganizationsRepository, _ executor: Executor) {
        self.organizationsRepository = organizationsRepository
        self.executor = executor
    }
    
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void) {
        executor.runOnBackgroundThread() { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(OrganizationsUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.organizationsRepository.searchForOrganizations(organizationsSearchDescriptor: organizationsSearchDescriptor) {
                    organizations in
                    _self.executor.runOnMainThread { completionBlock(organizations) }
                }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
}
