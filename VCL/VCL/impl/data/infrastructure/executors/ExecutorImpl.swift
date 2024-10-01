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
    private let dispatchQueueMain = DispatchQueue.main

    func runOnMain(_ block: @escaping @Sendable () -> Void) {
        self.dispatchQueueMain.async {
            block()
        }
    }
    
    func runOnBackground(_ block: @escaping @Sendable () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }
}
