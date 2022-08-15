//
//  EmptyExecutor.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//

import Foundation
@testable import VCL

class EmptyExecutor: Executor {
    
    func runOn(_ callinghQueue: DispatchQueue, _ block: @escaping () -> Void) {
        block()
    }
    
    func runOnMainThread(_ block: @escaping () -> Void) {
        block()
    }
    
    func runOnBackgroundThread(_ block: @escaping () -> Void) {
        block()
    }
}
