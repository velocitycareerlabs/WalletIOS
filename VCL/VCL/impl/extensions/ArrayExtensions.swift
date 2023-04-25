//
//  ArrayExtensions.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public func == (lhs: [Any], rhs: [Any] ) -> Bool {
    return NSArray(array: lhs).isEqual(to: rhs)
}

public func != (lhs: [Any], rhs: [Any] ) -> Bool {
    return !(lhs == rhs)
}
