//
//  DsptchQueueImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//

import Foundation

class DsptchQueueImpl: DsptchQueue {
    
    private let dispatchQueue: DispatchQueue
    
    init(_ sufix: String) {
        self.dispatchQueue = DispatchQueue(
            label: "\(GlobalConfig.VclPackage)." + sufix,
            attributes: .concurrent)
    }
    
    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void) {
        self.dispatchQueue.async(flags: flags) {
            block()
        }
    }
}
