//
//  PresentationRequestUseCase.swift
//  
//
//  Created by Michael Avoyan on 01/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol PresentationRequestUseCase: Sendable {
    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
    )
}
