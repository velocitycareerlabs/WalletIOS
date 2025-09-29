//
//  GlobalErrorStorage.swift
//  VCL
//
//  Created by Michael Avoyan on 18/09/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class GlobalErrorStorage {
    private var error: VCLError?
    private let queue = DispatchQueue(label: "GlobalErrorStorageQueue", attributes: .concurrent)

    func update(_ error: VCLError) {
        queue.async(flags: .barrier) {
            self.error = error
        }
    }

    func get() -> VCLError? {
        queue.sync {
            error
        }
    }

    func clear() {
        queue.async(flags: .barrier) {
            self.error = nil
        }
    }

    func hasError() -> Bool {
        queue.sync {
            error != nil
        }
    }
}
