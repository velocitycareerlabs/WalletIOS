//
//  SubmissionUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 10/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class SubmissionUseCaseImpl: SubmissionUseCase {
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
    
    func submit(submission: VCLSubmission,
                completionBlock: @escaping (VCLResult<VCLPresentationSubmissionResult>) -> Void) {
        executor.runOnBackgroundThread  { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(
                payload: submission.payload,
                iss: submission.iss,
                jti: submission.jti
            ) { signedJwtResult in
                do {
                    let jwt = try signedJwtResult.get()
                    self?.submissionRepository.submit(
                        submission: submission,
                        jwt: jwt
                    ) { submissionResult in
                        self?.executor.runOnMainThread { completionBlock(submissionResult) }
                    }
                } catch {
                    self?.executor.runOnMainThread { completionBlock(VCLResult.failure(VCLError(error: error))) }
                }
            }
        }
    }
}
