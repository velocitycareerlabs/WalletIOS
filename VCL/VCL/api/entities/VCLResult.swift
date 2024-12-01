//
//  VCLResult.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLResult<Value: Any> {
    case success(Value)
    case failure(VCLError)
}

extension VCLResult {
    func get() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
