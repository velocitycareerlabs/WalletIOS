//
//  VerifiedProfileUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class VerifiedProfileUseCaseImpl: VerifiedProfileUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let verifiedProfileRepository: VerifiedProfileRepository
    private let executor: Executor
    
    init(_ verifiedProfileRepository: VerifiedProfileRepository,
         _ executor: Executor) {
        self.verifiedProfileRepository = verifiedProfileRepository
        self.executor = executor
    }
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(SubmissionUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                self?.verifiedProfileRepository.getVerifiedProfile(
                    verifiedProfileDescriptor: verifiedProfileDescriptor
                ) { result in
                    self?.executor.runOnMainThread {
                        completionBlock(result)
                    }
                }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(description: "self is nil")))
            }
        }
    }
}
