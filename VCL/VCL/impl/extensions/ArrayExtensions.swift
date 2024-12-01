//
//  ArrayExtensions.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

extension Array {
    func toJsonArrayString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

func merge<T>(_ arrays: Array<T>?...) -> Set<T> {
    return arrays.compactMap{ $0 }
        .compactMap{ Set($0) }
        .reduce(Set<T>()){ $0.union($1) }
}

public func == (lhs: [Any], rhs: [Any] ) -> Bool {
    return NSArray(array: lhs).isEqual(to: rhs)
}

public func != (lhs: [Any], rhs: [Any] ) -> Bool {
    return !(lhs == rhs)
}
