//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialManifestByDeepLinkVerifierImpl: CredentialManifestByDeepLinkVerifier {
    
    let didDocumentRepository: ResolveDidDocumentRepository
    
    init(_ didDocumentRepository: ResolveDidDocumentRepository) {
        self.didDocumentRepository = didDocumentRepository
    }
    
    func verifyCredentialManifest(
        credentialManifest: VCLCredentialManifest,
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let did = deepLink.did {
            didDocumentRepository.resolveDidDocument(did: did) { [weak self] didDocumentResult in
                do {
                    let didDocument = try didDocumentResult.get()
                    self?.verify(
                        credentialManifest: credentialManifest,
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
        credentialManifest: VCLCredentialManifest,
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (didDocument.id == credentialManifest.issuerId ||
            didDocument.alsoKnownAs.contains(credentialManifest.issuerId)
        ) {
            completionBlock(VCLResult.success(true))
        } else {
            onError(
                errorCode: VCLErrorCode.MismatchedRequestIssuerDid,
                errorMessage: "credential manifest: \(credentialManifest.jwt.encodedJwt) \ndidDocument: \(didDocument)",
                completionBlock: completionBlock
            )
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

