//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialsByDeepLinkVerifierImpl: CredentialsByDeepLinkVerifier {
    
    let didDocumentRepository: ResolveDidDocumentRepository

    init(_ didDocumentRepository: ResolveDidDocumentRepository) {
        self.didDocumentRepository = didDocumentRepository
    }
    
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let did = deepLink.did {
            didDocumentRepository.resolveDidDocument(did: did) { [weak self] didDocumentResult in
                do {
                    let didDocument = try didDocumentResult.get()
                    self?.verify(
                        jwtCredentials: jwtCredentials,
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
        jwtCredentials: [VCLJwt],
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let mismatchedCredential = jwtCredentials.first(
            where: { didDocument.id != $0.iss && !didDocument.alsoKnownAs.contains($0.iss ?? "") }
        ) {
            VCLLog.e("mismatched credential: \(mismatchedCredential.encodedJwt) \ndidDocument: \(didDocument)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedCredentialIssuerDid.rawValue)))
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
