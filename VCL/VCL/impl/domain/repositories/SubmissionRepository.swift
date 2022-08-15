//
//  PresentationSubmissionRepository.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//

import Foundation

protocol SubmissionRepository {
    func submit(submission: VCLSubmission,
                jwt: VCLJWT,
                completionBlock: @escaping (VCLResult<VCLSubmissionResult>) -> Void)
}
