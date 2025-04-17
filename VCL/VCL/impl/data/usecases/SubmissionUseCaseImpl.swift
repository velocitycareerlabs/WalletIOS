//
//  SubmissionUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 10/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class SubmissionUseCaseImpl: SubmissionUseCase {
    
    private let submissionRepository: SubmissionRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(
        _ submissionRepository: SubmissionRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ executor: Executor
    ) {
        self.submissionRepository = submissionRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func submit(
        submission: VCLSubmission,
        authToken: VCLAuthToken?,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        executor.runOnBackground  { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(
                jwtDescriptor: VCLJwtDescriptor(
                    payload: submission.generatePayload(iss: submission.didJwk.did),
                    jti: submission.jti,
                    iss: submission.didJwk.did
                ), 
                didJwk: submission.didJwk,
                remoteCryptoServicesToken: submission.remoteCryptoServicesToken
            ) {
                [weak self] signedJwtResult in
                guard let self = self else { return }
                    do {
                        let jwt = try signedJwtResult.get()
                        self.submissionRepository.submit(
                            submission: submission,
                            jwt: jwt,
                            authToken: authToken,
                        ) { submissionResult in
                            self.executor.runOnMain { completionBlock(submissionResult) }
                        }
                    } catch {
                        self.executor.runOnMain { completionBlock(VCLResult.failure(VCLError(error: error))) }
                    }
                }
        }
    }
}
