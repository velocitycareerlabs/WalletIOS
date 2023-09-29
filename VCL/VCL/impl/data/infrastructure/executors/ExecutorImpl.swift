//
//  ExecutorImpl.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class ExecutorImpl: Executor {
    private var dispatchQueueMain: DispatchQueue
    
    init() {
        self.dispatchQueueMain = DispatchQueue.main
    }
    
    func runOnMain(_ block: @escaping () -> Void) {
        self.dispatchQueueMain.async {
            block()
        }
    }
    
    func runOnBackground(_ block: @escaping () -> Void) {
        DispatchQueue.global().async {
            block()
        }
    }
}
