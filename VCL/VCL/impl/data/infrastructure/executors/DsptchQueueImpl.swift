//
//  DsptchQueueImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

import Foundation

class DsptchQueueImpl: DsptchQueue {
    
    private let dispatchQueue: DispatchQueue
    
    init(_ suffix: String) {
        self.dispatchQueue = DispatchQueue(
            label: "\(GlobalConfig.VclPackage)." + suffix,
            attributes: .concurrent)
    }
    
    func async(flags: DispatchWorkItemFlags, _ block: @escaping @Sendable () -> Void) {
        self.dispatchQueue.async(flags: flags) {
            block()
        }
    }
    
    func sync<T>(_ block: @escaping @Sendable () -> T) -> T {
        return self.dispatchQueue.sync {
            return block()
        }
    }
}
