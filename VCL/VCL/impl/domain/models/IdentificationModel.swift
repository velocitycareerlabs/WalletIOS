//
//  IdentificationModel.swift
//  VCL
//
//  Created by Michael Avoyan on 18/07/2021.
//

import Foundation

protocol IdentificationModel: Model {
    var data: VCLToken? { get }
    func submit(
        identificationSubmission: VCLIdentificationSubmission,
        completionBlock: @escaping (VCLResult<VCLIdentificationSubmissionResult>) -> Void
    )
}
