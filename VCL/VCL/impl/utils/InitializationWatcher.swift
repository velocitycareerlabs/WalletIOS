//
//  InitializationWatcher.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

final class InitializationWatcher {
    private let initAmount: Int
    private var initCount = 0
    private var _errors: [VCLError] = []
    
    private let queue = DispatchQueue(label: "InitializationWatcher.queue", attributes: .concurrent)
    
    var errors: [VCLError] {
        queue.sync {
            _errors
        }
    }
    
    init(initAmount: Int) {
        self.initAmount = initAmount
    }

    func onInitializedModel(error: VCLError?, enforceFailure: Bool = false) -> Bool {
        var result = false
        queue.sync(flags: .barrier) {
            initCount += 1
            if let e = error {
                _errors.append(e)
            }
            result = isInitializationComplete(enforceFailure)
        }
        return result
    }
    
    func firstError() -> VCLError? {
        queue.sync {
            _errors.first
        }
    }
    
    private func isInitializationComplete(_ enforceFailure: Bool) -> Bool {
        initCount == initAmount || enforceFailure
    }
}
