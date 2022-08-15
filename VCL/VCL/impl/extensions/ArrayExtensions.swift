//
//  ArrayExtensions.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//

import Foundation

public func == (lhs: [Any], rhs: [Any] ) -> Bool {
    return NSArray(array: lhs).isEqual(to: rhs)
}

public func != (lhs: [Any], rhs: [Any] ) -> Bool {
    return !(lhs == rhs)
}
