//
//  VerifiedProfileRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 28/10/2021.
//

import Foundation

protocol VerifiedProfileRepository {
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        completionBlock: @escaping (VCLResult<VCLVerifiedProfile>) -> Void
    )
}
