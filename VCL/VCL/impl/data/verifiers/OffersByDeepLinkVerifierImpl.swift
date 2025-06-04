//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class OffersByDeepLinkVerifierImpl: OffersByDeepLinkVerifier {
    
    let didDocumentRepository: ResolveDidDocumentRepository

    init(_ didDocumentRepository: ResolveDidDocumentRepository) {
        self.didDocumentRepository = didDocumentRepository
    }
    
    func verifyOffers(
        offers: VCLOffers,
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let did = deepLink.did {
            didDocumentRepository.resolveDidDocument(did: did) { [weak self] didDocumentResult in
                do {
                    let didDocument = try didDocumentResult.get()
                    self?.verify(
                        offers: offers,
                        didDocument: didDocument,
                        completionBlock: completionBlock
                    )
                } catch {
                    self?.onError(
                        errorMessage: "Failed to resolve DID Document: $\(did)\n\(error)",
                        completionBlock: completionBlock
                    )
                }
            }
        } else {
            onError(
                errorMessage: "DID not found in deep link: \(deepLink.value)",
                completionBlock: completionBlock
            )
        }
    }
    
    private func verify(
        offers: VCLOffers,
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let mismatchedOffer = offers.all.first(
            where: { didDocument.id != $0.issuerId && !didDocument.alsoKnownAs.contains($0.issuerId) }
        ) {
            VCLLog.e("mismatched offer: \(mismatchedOffer.payload) \ndidDocument: \(didDocument)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedOfferIssuerDid.rawValue)))
        } else {
            completionBlock(.success(true))
        }
    }
    
    private func onError(
        errorCode: VCLErrorCode = VCLErrorCode.SdkError,
        errorMessage: String,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        VCLLog.e(errorMessage)
        completionBlock(
            (VCLResult.failure(VCLError(errorCode: errorCode.rawValue, message: errorMessage)))
        )
    }
}
