//
//  DsptchQueue.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol DsptchQueue {
    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void)
}
