//
//  EmptyDsptchQueue.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class EmptyDsptchQueue: DsptchQueue {

    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void) {
        block()
    }
}
