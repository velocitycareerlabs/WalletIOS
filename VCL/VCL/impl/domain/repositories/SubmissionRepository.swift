//
//  PresentationSubmissionRepository.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol SubmissionRepository {
    func submit(submission: VCLSubmission,
                jwt: VCLJwt,
                completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void)
}
