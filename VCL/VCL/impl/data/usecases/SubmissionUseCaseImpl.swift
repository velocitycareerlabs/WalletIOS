//
//  SubmissionUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 10/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class SubmissionUseCaseImpl: SubmissionUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let submissionRepository: SubmissionRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(_ submissionRepository: SubmissionRepository,
         _ jwtServiceRepository: JwtServiceRepository,
         _ executor: Executor) {
        self.submissionRepository = submissionRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func submit(
        submission: VCLSubmission,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        executor.runOnBackgroundThread  { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(SubmissionUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.jwtServiceRepository.generateSignedJwt(
                    jwtDescriptor: VCLJwtDescriptor(
                        payload: submission.payload,
                        jti: submission.jti,
                        iss: submission.iss
                    )) { signedJwtResult in
                        do {
                            let jwt = try signedJwtResult.get()
                            _self.submissionRepository.submit(
                                submission: submission,
                                jwt: jwt
                            ) { submissionResult in
                                _self.executor.runOnMainThread { completionBlock(submissionResult) }
                            }
                        } catch {
                            _self.executor.runOnMainThread { completionBlock(VCLResult.failure(VCLError(error: error))) }
                        }
                    }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
}
