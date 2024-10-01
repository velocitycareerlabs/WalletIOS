//
//  Executor.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol Executor: Sendable {
    func runOnMain(_ block: @escaping @Sendable () -> Void)
    func runOnBackground(_ block: @escaping @Sendable () -> Void)
}
