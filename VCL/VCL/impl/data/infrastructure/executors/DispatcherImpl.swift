//
//  DispatcherImpl.swift
//  
//
//  Created by Michael Avoyan on 03/05/2021.
//

import Foundation

class DispatcherImpl: Dispatcher {
    private let dispatchGroup: DispatchGroup
    
    init() {
        dispatchGroup = DispatchGroup()
    }
    
    func enter() {
        dispatchGroup.enter()
    }
    
    func leave() {
        dispatchGroup.leave()
    }
    
    func notify(qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        dispatchGroup.notify(qos: qos, flags: flags, queue: queue, execute: work)
    }
}
