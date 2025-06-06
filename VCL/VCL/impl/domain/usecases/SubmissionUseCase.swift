//
//  SubmissionUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol SubmissionUseCase {
    func submit(
        submission: VCLSubmission,
        authToken: VCLAuthToken?,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    )
}

extension SubmissionUseCase {
    func submit(
        submission: VCLSubmission,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        submit(submission: submission, authToken: nil, completionBlock: completionBlock)
    }
}
