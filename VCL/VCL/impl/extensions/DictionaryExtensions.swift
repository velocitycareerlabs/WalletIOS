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
    func update(_ dict: [String: Sendable], set value: Sendable, for key: String) -> [String: Sendable] {
        var newDict = dict
        for (k, v) in newDict {
            if k == key {
                newDict[k] = value
            } else if let subDict = v as? [String: Sendable] {
                newDict[k] = update(subDict, set: value, for: key)
            } else if let subArray = v as? [[String: Sendable]] {
                var newArray = [[String: Sendable]]()
                for item in subArray {
                    newArray.append(update(item, set: value, for: key))
                }
                newDict[k] = newArray
            }
        }
        return newDict
    }
}

public func == (lhs: [String: Sendable], rhs: [String: Sendable]) -> Bool {
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public func != (lhs: [String: Sendable], rhs: [String: Sendable]) -> Bool {
    return !(lhs == rhs)
}
