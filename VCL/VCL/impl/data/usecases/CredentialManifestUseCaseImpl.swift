//
//  CredentialManifestUseCaseImpl.swift
//
//
//  Created by Michael Avoyan on 09/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialManifestUseCaseImpl: CredentialManifestUseCase {

    private let credentialManifestRepository: CredentialManifestRepository
    private let resolveDidDocumentRepository: ResolveDidDocumentRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier
    private let executor: Executor

    init(
        _ credentialManifestRepository: CredentialManifestRepository,
        _ resolveDidDocumentRepository: ResolveDidDocumentRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.credentialManifestRepository = credentialManifestRepository
        self.resolveDidDocumentRepository = resolveDidDocumentRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.credentialManifestByDeepLinkVerifier = credentialManifestByDeepLinkVerifier
        self.executor = executor
    }

    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.credentialManifestRepository.getCredentialManifest(
                credentialManifestDescriptor: credentialManifestDescriptor
            ) {
                [weak self] credentialManifestResult in
                guard let self = self else { return }
                do {
                    self.decodeCredentialManifestJwt(
                        encodedJwt: try credentialManifestResult.get(),
                        credentialManifestDescriptor: credentialManifestDescriptor,
                        verifiedProfile: verifiedProfile,
                        completionBlock: completionBlock
                    )
                } catch {
                    self.onError(
                        ErrorTaxonomy.classifyClientRequestFetch(
                            VCLError(error: error),
                            requestUri: credentialManifestDescriptor.endpoint,
                            requestKind: ErrorTaxonomy.requestKindIssuing
                        ),
                        completionBlock
                    )
                }
            }
        }
    }

    private func decodeCredentialManifestJwt(
        encodedJwt: String,
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        jwtServiceRepository.decodeJwt(encodedJwt: encodedJwt) { [weak self] jwtResult in
            guard let self = self else { return }
            do {
                let credentialManifest = VCLCredentialManifest(
                    jwt: try jwtResult.get(),
                    vendorOriginContext: credentialManifestDescriptor.vendorOriginContext,
                    verifiedProfile: verifiedProfile,
                    deepLink: credentialManifestDescriptor.deepLink,
                    didJwk: credentialManifestDescriptor.didJwk,
                    remoteCryptoServicesToken: credentialManifestDescriptor.remoteCryptoServicesToken
                )
                guard credentialManifest.iss.isEmpty == false else {
                    self.onError(missingJwtIssError(), completionBlock)
                    return
                }
                self.resolveCredentialManifestDid(
                    credentialManifest,
                    completionBlock
                )
            } catch {
                self.onError(
                    ErrorTaxonomy.classifyRequestValidation(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindIssuing,
                        requestDid: nil
                    ),
                    completionBlock
                )
            }
        }
    }

    private func resolveCredentialManifestDid(
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        resolveDidDocumentRepository.resolveDidDocument(did: credentialManifest.iss) { [weak self] didDocumentResult in
            do {
                let didDocument = try didDocumentResult.get()
                if let error = self?.validateDidDocument(didDocument, credentialManifest: credentialManifest) {
                    self?.onError(error, completionBlock)
                    return
                }
                self?.verifyCredentialManifestJwt(
                    credentialManifest,
                    didDocument,
                    completionBlock
                )
            } catch {
                self?.onError(
                    ErrorTaxonomy.classifyDidResolution(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindIssuing,
                        requestDid: credentialManifest.iss
                    ),
                    completionBlock
                )
            }
        }
    }

    private func verifyCredentialManifestJwt(
        _ credentialManifest: VCLCredentialManifest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        guard let kid = credentialManifest.jwt.kid else {
            onError(missingJwtKidError(requestDid: credentialManifest.iss), completionBlock)
            return
        }
        guard let publicJwk = didDocument.getPublicJwk(kid: kid) else {
            onError(unresolvedJwtKeyError(kid: kid, requestDid: credentialManifest.iss), completionBlock)
            return
        }
        jwtServiceRepository.verifyJwt(
            jwt: credentialManifest.jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: credentialManifest.remoteCryptoServicesToken
        ) { [weak self] verificationResult in
            do {
                _ = try verificationResult.get()
                self?.verifyCredentialManifestByDeepLink(
                    credentialManifest,
                    didDocument,
                    completionBlock
                )
            } catch {
                self?.onError(
                    ErrorTaxonomy.classifyRequestValidation(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindIssuing,
                        requestDid: credentialManifest.iss
                    ),
                    completionBlock
                )
            }
        }
    }

    private func validateDidDocument(
        _ didDocument: VCLDidDocument,
        credentialManifest: VCLCredentialManifest
    ) -> VCLError? {
        if didDocument.payload.isEmpty || didDocument.hasVerificationMethods == false {
            return ErrorTaxonomy.classifyDidResolution(
                VCLError(message: "public jwk not found for kid"),
                requestKind: ErrorTaxonomy.requestKindIssuing,
                requestDid: credentialManifest.iss
            )
        }
        return nil
    }

    private func missingJwtKidError(requestDid: String?) -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "JWT kid is missing"),
            requestKind: ErrorTaxonomy.requestKindIssuing,
            requestDid: requestDid
        )
    }

    private func missingJwtIssError() -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "JWT iss is missing"),
            requestKind: ErrorTaxonomy.requestKindIssuing,
            requestDid: nil
        )
    }

    private func unresolvedJwtKeyError(kid: String, requestDid: String?) -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "public jwk not found for kid: \(kid)"),
            requestKind: ErrorTaxonomy.requestKindIssuing,
            requestDid: requestDid
        )
    }

    private func verifyCredentialManifestByDeepLink(
        _ credentialManifest: VCLCredentialManifest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let deepLink = credentialManifest.deepLink {
            credentialManifestByDeepLinkVerifier.verifyCredentialManifest(
                credentialManifest: credentialManifest,
                deepLink: deepLink,
                didDocument: didDocument
            ) { [weak self] in
                do {
                    try $0.get()
                    self?.executor.runOnMain {
                        completionBlock(.success(credentialManifest))
                    }
                }
                catch {
                    self?.onError(
                        ErrorTaxonomy.classifyRequestValidation(
                            VCLError(error: error),
                            requestKind: ErrorTaxonomy.requestKindIssuing,
                            requestDid: credentialManifest.iss
                        ),
                        completionBlock
                    )
                }
            }
        } else {
            VCLLog.d("Deep link was not provided => nothing to verify")
            executor.runOnMain {
                completionBlock(VCLResult.success(credentialManifest))
            }
        }
    }

    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnMain {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
