//
//  ExecutorImpl.swift
//
//
//  Created by Michael Avoyan on 02/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class ExecutorImpl: Executor {

    // Singleton instance
    static let instance = ExecutorImpl()
    
    // Private init to prevent external instantiation
    private init() {}
    
    func runOnMain(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    func runOnBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }
}
