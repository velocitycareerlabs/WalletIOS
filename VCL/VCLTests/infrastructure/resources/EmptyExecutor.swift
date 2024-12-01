//
//  EmptyExecutor.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

final class EmptyExecutor: Executor {
    
    func runOnMain(_ block: @escaping () -> Void) {
        block()
    }
    
    func runOnBackground(_ block: @escaping () -> Void) {
        block()
    }
}
