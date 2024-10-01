//
//  GenerateOffersUseCase.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol GenerateOffersUseCase: Sendable {
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        completionBlock: @escaping @Sendable (VCLResult<VCLOffers>) -> Void
    )
}
