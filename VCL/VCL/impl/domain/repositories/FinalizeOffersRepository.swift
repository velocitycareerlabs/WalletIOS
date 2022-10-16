//
//  FinalizeOffersRepository.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol FinalizeOffersRepository {
    func finalizeOffers(token: VCLToken,
                        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
                        completionBlock: @escaping (VCLResult<[String]>) -> Void)
}
