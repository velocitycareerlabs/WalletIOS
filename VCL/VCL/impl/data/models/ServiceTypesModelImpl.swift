//
//  ServiceTypesModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 29/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class ServiceTypesModelImpl: ServiceTypesModel {
    var data: VCLServiceTypesDynamic?
    
    private let serviceTypesUseCase: ServiceTypesUseCase
    
    init(_ serviceTypesUseCase: ServiceTypesUseCase) {
        self.serviceTypesUseCase = serviceTypesUseCase
    }
    
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    ) {
        serviceTypesUseCase.getServiceTypes(cacheSequence: cacheSequence) { [weak self] result in
            do {
                self?.data = try result.get()
            } catch {}
            completionBlock(result)
        }
    }
}
