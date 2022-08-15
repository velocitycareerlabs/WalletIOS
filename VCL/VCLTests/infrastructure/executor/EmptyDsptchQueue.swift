//
//  EmptyDsptchQueue.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2022.
//

import Foundation
@testable import VCL

class EmptyDsptchQueue: DsptchQueue {

    func _async(flags: DispatchWorkItemFlags, _ block: @escaping () -> Void) {
        block()
    }
}
