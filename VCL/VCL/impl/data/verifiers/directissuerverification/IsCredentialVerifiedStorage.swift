//
//  IsCredentialVerifiedStorage.swift
//  VCL
//
//  Created by Michael Avoyan on 18/09/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class IsCredentialVerifiedStorage {
    private var isVerified = false
    private let queue = DispatchQueue(label: "IsCredentialVerifiedStorageQueue", attributes: .concurrent)

    func update(_ value: Bool) {
        queue.async(flags: .barrier) {
            self.isVerified = value
        }
    }

    func get() -> Bool {
        queue.sync {
            isVerified
        }
    }
}
