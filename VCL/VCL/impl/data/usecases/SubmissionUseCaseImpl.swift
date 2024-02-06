//
//  SubmissionUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 10/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class SubmissionUseCaseImpl: SubmissionUseCase {
    
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
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        executor.runOnBackground  { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(
                didJwk: didJwk,
                jwtDescriptor: VCLJwtDescriptor(
                    payload: submission.generatePayload(iss: didJwk.did),
                    jti: submission.jti,
                    iss: didJwk.did
                ),
                remoteCryptoServicesToken: remoteCryptoServicesToken
            ) { signedJwtResult in
                    do {
                        let jwt = try signedJwtResult.get()
                        self?.submissionRepository.submit(
                            submission: submission,
                            jwt: jwt
                        ) { submissionResult in
                            self?.executor.runOnMain { completionBlock(submissionResult) }
                        }
                    } catch {
                        self?.executor.runOnMain { completionBlock(VCLResult.failure(VCLError(error: error))) }
                    }
                }
        }
    }
}
