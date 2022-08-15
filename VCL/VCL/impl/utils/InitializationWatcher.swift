//
//  InitializationWatcher.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//

class InitializationWatcher {
    private let initAmount: Int
    private var initCount = 0
    
    private(set) var errors: Array<VCLError> = Array()
    
    init(initAmount: Int) {
        self.initAmount = initAmount
    }

    func onInitializedModel(error: VCLError?, enforceFailure: Bool=false) -> Bool{
        initCount += 1
        if let e = error {
            errors.append(e)
        }
        return isInitializationComplete(enforceFailure)
    }
    func firstError() -> VCLError? {
        return errors.first
    }
    private func isInitializationComplete(_ enforceFailure: Bool) -> Bool{
        return initCount == initAmount || enforceFailure
    }
}
