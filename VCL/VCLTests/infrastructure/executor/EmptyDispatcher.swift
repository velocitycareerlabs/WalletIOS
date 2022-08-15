//
//  EmptyDispatcher.swift
//  
//
//  Created by Michael Avoyan on 03/05/2021.
//

import Foundation
@testable import VCL

class EmptyDispatcher: Dispatcher {
    func enter() {
        
    }
    
    func leave() {
        
    }
    
    func notify(qos: DispatchQoS, flags: DispatchWorkItemFlags, queue: DispatchQueue, execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
