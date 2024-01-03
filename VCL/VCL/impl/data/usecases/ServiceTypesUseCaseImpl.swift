//
//  ServiceTypesUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 29/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class ServiceTypesUseCaseImpl: ServiceTypesUseCase {
    private let serviceTypesRepository: ServiceTypesRepository
    private let executor: Executor
    
    init(
        _ serviceTypesRepository: ServiceTypesRepository,
        _ executor: Executor
    ) {
        self.serviceTypesRepository = serviceTypesRepository
        self.executor = executor
    }
    
    func getServiceTypes(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    ) {
        executor.runOnBackground  { [weak self] in
            self?.serviceTypesRepository.getServiceTypes(cacheSequence: cacheSequence) { serviceTypes in
                self?.executor.runOnMain { completionBlock(serviceTypes) }
            }
        }
    }
}
