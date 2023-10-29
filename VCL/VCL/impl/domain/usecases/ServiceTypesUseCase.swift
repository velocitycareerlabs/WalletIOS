//
//  ServiceTypesUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 29/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol ServiceTypesUseCase {
    func getServiceTypes(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    )
}
