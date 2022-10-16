//
//  GenerateOffersRepository.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol GenerateOffersRepository {
    func generateOffers(token: VCLToken,
                        generateOffersDescriptor: VCLGenerateOffersDescriptor,
                        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void)
}
