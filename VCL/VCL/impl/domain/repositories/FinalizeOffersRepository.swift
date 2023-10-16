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
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        proof: VCLJwt,
        completionBlock: @escaping (VCLResult<[String]>) -> Void
    )
}
