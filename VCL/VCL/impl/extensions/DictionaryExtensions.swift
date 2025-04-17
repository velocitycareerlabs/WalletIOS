//
//  DictionaryExtensions.swift
//  
//
//  Created by Michael Avoyan on 26/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Dictionary {
    func toJsonString() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
    /// A recursive function that replaces all values for a given key
    func update(_ dict: [String: Any], set value: Any, for key: String) -> [String: Any] {
        var newDict = dict
        for (k, v) in newDict {
            if k == key {
                newDict[k] = value
            } else if let subDict = v as? [String: Any] {
                newDict[k] = update(subDict, set: value, for: key)
            } else if let subArray = v as? [[String: Any]] {
                var newArray = [[String: Any]]()
                for item in subArray {
                    newArray.append(update(item, set: value, for: key))
                }
                newDict[k] = newArray
            }
        }
        return newDict
    }
}

public func == (lhs: [String: Any], rhs: [String: Any]) -> Bool {
    guard lhs.count == rhs.count else { return false }

    for (key, lhsValue) in lhs {
        guard let rhsValue = rhs[key], isEqual(lhsValue, rhsValue) else {
            return false
        }
    }
    return true
}

private func isEqual(_ lhs: Any, _ rhs: Any) -> Bool {
    if isOptionalNil(lhs), isOptionalNil(rhs) { return true }

    switch (lhs, rhs) {
    case let (lhs as Int, rhs as Int): return lhs == rhs
    case let (lhs as Float, rhs as Float): return lhs == rhs
    case let (lhs as Double, rhs as Double): return lhs == rhs
    case let (lhs as String, rhs as String): return lhs == rhs
    case let (lhs as Bool, rhs as Bool): return lhs == rhs
    case let (lhs as UUID, rhs as UUID): return lhs == rhs
    case let (lhs as NSNumber, rhs as NSNumber): return lhs == rhs
    case let (lhs as [String: Any], rhs as [String: Any]): return lhs == rhs
    case let (lhs as [Any], rhs as [Any]):
        return lhs.count == rhs.count &&
               zip(lhs, rhs).allSatisfy { isEqual($0, $1) }
    case let (lhs as any Equatable, rhs):
        return (lhs as? AnyHashable) == (rhs as? AnyHashable)
    default:
        return false
    }
}

private func isOptionalNil(_ value: Any) -> Bool {
    let mirror = Mirror(reflecting: value)
    return mirror.displayStyle == .optional && mirror.children.count == 0
}


public func != (lhs: [String: Any], rhs: [String: Any]) -> Bool {
    return !(lhs == rhs)
}
