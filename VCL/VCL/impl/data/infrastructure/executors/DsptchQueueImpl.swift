//
//  DsptchQueueImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class DsptchQueueImpl: DsptchQueue {
    
    private let dispatchQueue: DispatchQueue
    
    init(_ sufix: String) {
        self.dispatchQueue = DispatchQueue(
            label: "\(GlobalConfig.VclPackage)." + sufix,
            attributes: .concurrent)
    }
    
    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void) {
        self.dispatchQueue.async(flags: flags) {
            block()
        }
    }
}
