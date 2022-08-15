//
//  Dispatcher.swift
//  
//
//  Created by Michael Avoyan on 03/05/2021.
//

import Foundation

protocol Dispatcher {
    func enter()
    func leave()
    func notify(qos: DispatchQoS, flags: DispatchWorkItemFlags, queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void)
}

extension Dispatcher {
    func notify(qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        notify(qos: qos, flags: flags, queue: queue, execute: work)
    }
}
