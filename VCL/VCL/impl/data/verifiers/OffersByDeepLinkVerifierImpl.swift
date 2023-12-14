//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class OffersByDeepLinkVerifierImpl: OffersByDeepLinkVerifier {
    func verifyOffers(
        offers: VCLOffers,
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let errorOffer = offers.all.first(where: { $0.issuerId != deepLink.did }) {
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedOfferIssuerDid.rawValue)))
        } else {
            completionBlock(.success(true))
        }
    }
}
