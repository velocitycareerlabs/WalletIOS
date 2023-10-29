//
//  ServiceTypesModel.swift
//  VCL
//
//  Created by Michael Avoyan on 29/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol ServiceTypesModel: Model {
    var data: VCLServiceTypesDynamic? { get }
    
    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    )
}
