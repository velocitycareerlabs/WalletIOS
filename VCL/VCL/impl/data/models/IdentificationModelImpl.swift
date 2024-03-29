//
//  IdentificationModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 18/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class IdentificationModelImpl: IdentificationModel {
    
    private(set) var data: VCLToken? = nil
    private let identificationSubmissionUseCase: IdentificationSubmissionUseCase
    
    init(identificationSubmissionUseCase: IdentificationSubmissionUseCase) {
        self.identificationSubmissionUseCase = identificationSubmissionUseCase
    }
    
    func submit(
        identificationSubmission: VCLIdentificationSubmission,
        completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void
    ) {
        identificationSubmissionUseCase.submit(
            submission: identificationSubmission
        ) { [weak self] result in
            do {
                self?.data = try result.get().sessionToken
            } catch {}
            completionBlock(result)
        }
    }
    
}
