//
//  CompleteContextsStorage.swift
//  VCL
//
//  Created by Michael Avoyan on 18/09/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CompleteContextsStorage {
    private var storage = [[String: Any]]()
    private let queue = DispatchQueue(label: "CompleteContextsStorageQueue", attributes: .concurrent)
    
    func append(_ completeContext: [String: Any]) {
        queue.async(flags: .barrier) {
            self.storage.append(completeContext)
        }
    }
    
    func isEmpty() -> Bool {
        queue.sync {
            storage.isEmpty
        }
    }
    
    func get() -> [[String: Any]] {
        queue.sync {
            storage
        }
    }
}
