//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class PresentationRequestByDeepLinkVerifierImpl: PresentationRequestByDeepLinkVerifier {
    
    let didDocumentRepository: ResolveDidDocumentRepository

    init(_ didDocumentRepository: ResolveDidDocumentRepository) {
        self.didDocumentRepository = didDocumentRepository
    }
    
    func verifyPresentationRequest(
        presentationRequest: VCLPresentationRequest,
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let did = deepLink.did {
            didDocumentRepository.resolveDidDocument(did: did) { [weak self] didDocumentResult in
                do {
                    let didDocument = try didDocumentResult.get()
                    self?.verify(
                        presentationRequest: presentationRequest,
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
        presentationRequest: VCLPresentationRequest,
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (didDocument.id == presentationRequest.iss ||
            didDocument.alsoKnownAs.contains(presentationRequest.iss)
        ) {
            completionBlock(.success(true))
        } else {
            VCLLog.e("presentation request: \(presentationRequest.jwt.encodedJwt) \ndidDocument: \(didDocument)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)))
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
