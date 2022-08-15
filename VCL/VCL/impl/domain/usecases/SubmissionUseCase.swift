//
//  SubmissionUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//

import Foundation

protocol SubmissionUseCase {
    func submit(submission: VCLSubmission,
               completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void)
}
