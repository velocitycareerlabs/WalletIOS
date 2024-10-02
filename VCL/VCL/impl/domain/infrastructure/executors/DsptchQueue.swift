//
//  DsptchQueue.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol DsptchQueue {
    func async(flags: DispatchWorkItemFlags, _ block: @escaping @Sendable () -> Void)
    func sync<T>(_ block: @escaping @Sendable () -> T) -> T
}
