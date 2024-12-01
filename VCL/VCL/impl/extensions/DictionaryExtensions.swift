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
    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

public func != (lhs: [String: Any], rhs: [String: Any]) -> Bool {
    return !(lhs == rhs)
}
