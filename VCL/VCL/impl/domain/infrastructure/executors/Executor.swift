//
//  Executor.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol Executor {
//    func runOn(_ callinghQueue: DispatchQueue, _ block: @escaping () -> Void)
    func runOnMainThread(_ block: @escaping () -> Void)
    func runOnBackgroundThread(_ block: @escaping () -> Void)
}
