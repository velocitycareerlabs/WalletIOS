//
//  DsptchQueue.swift
//  VCL
//
//  Created by Michael Avoyan on 15/08/2022.
//

import Foundation

protocol DsptchQueue {
    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void)
}
