//
//  IdentificationModel.swift
//  VCL
//
//  Created by Michael Avoyan on 18/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol IdentificationModel: Model {
    var data: VCLToken? { get }
    func submit(
        identificationSubmission: VCLIdentificationSubmission,
        completionBlock: @escaping (VCLResult<VCLIdentificationSubmissionResult>) -> Void
    )
}
