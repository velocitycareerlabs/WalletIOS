//
//  PresentationRequestUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 02/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class PresentationRequestUseCaseImpl: PresentationRequestUseCase {

    private let presentationRequestRepository: PresentationRequestRepository
    private let resolveDidDocumentRepository: ResolveDidDocumentRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let presentationRequestByDeepLinkVerifier: PresentationRequestByDeepLinkVerifier
    private let executor: Executor

    init(
        _ presentationRequestRepository: PresentationRequestRepository,
        _ resolveDidDocumentRepository: ResolveDidDocumentRepository,
        _ verifyRepository: JwtServiceRepository,
        _ presentationRequestByDeepLinkVerifier: PresentationRequestByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.presentationRequestRepository = presentationRequestRepository
        self.resolveDidDocumentRepository = resolveDidDocumentRepository
        self.jwtServiceRepository = verifyRepository
        self.presentationRequestByDeepLinkVerifier = presentationRequestByDeepLinkVerifier
        self.executor = executor
    }

    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.presentationRequestRepository.getPresentationRequest(
                presentationRequestDescriptor: presentationRequestDescriptor
            ) { encodedJwtStrResult in
                guard let self = self else { return }
                do {
                    self.decodePresentationRequestJwt(
                        encodedJwt: try encodedJwtStrResult.get(),
                        presentationRequestDescriptor: presentationRequestDescriptor,
                        verifiedProfile: verifiedProfile,
                        completionBlock: completionBlock
                    )
                } catch {
                    self.onError(
                        ErrorTaxonomy.classifyClientRequestFetch(
                            VCLError(error: error),
                            requestUri: presentationRequestDescriptor.endpoint,
                            requestKind: ErrorTaxonomy.requestKindPresentation
                        ),
                        completionBlock
                    )
                }
            }
        }
    }

    private func decodePresentationRequestJwt(
        encodedJwt: String,
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        jwtServiceRepository.decodeJwt(encodedJwt: encodedJwt) { [weak self] jwtResult in
            guard let self = self else { return }
            do {
                let presentationRequest = VCLPresentationRequest(
                    jwt: try jwtResult.get(),
                    verifiedProfile: verifiedProfile,
                    deepLink: presentationRequestDescriptor.deepLink,
                    pushDelegate: presentationRequestDescriptor.pushDelegate,
                    didJwk: presentationRequestDescriptor.didJwk,
                    remoteCryptoServicesToken: presentationRequestDescriptor.remoteCryptoServicesToken
                )
                guard presentationRequest.iss.isEmpty == false else {
                    self.onError(missingJwtIssError(), completionBlock)
                    return
                }
                self.resolvePresentationRequestDid(
                    presentationRequest,
                    completionBlock
                )
            } catch {
                self.onError(
                    ErrorTaxonomy.classifyRequestValidation(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindPresentation,
                        requestDid: nil
                    ),
                    completionBlock
                )
            }
        }
    }

    private func resolvePresentationRequestDid(
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        resolveDidDocumentRepository.resolveDidDocument(
            did: presentationRequest.iss
        ) { [weak self] didDocumentResult in
            do {
                let didDocument = try didDocumentResult.get()
                if let error = self?.validateDidDocument(didDocument, presentationRequest: presentationRequest) {
                    self?.onError(error, completionBlock)
                    return
                }
                self?.verifyPresentationRequest(
                    presentationRequest,
                    didDocument,
                    completionBlock
                )
            } catch {
                self?.onError(
                    ErrorTaxonomy.classifyDidResolution(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindPresentation,
                        requestDid: presentationRequest.iss
                    ),
                    completionBlock
                )
            }
        }
    }

    private func verifyPresentationRequest(
        _ presentationRequest: VCLPresentationRequest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        guard let kid = presentationRequest.jwt.kid else {
            onError(missingJwtKidError(requestDid: presentationRequest.iss), completionBlock)
            return
        }
        guard let publicJwk = didDocument.getPublicJwk(kid: kid) else {
            onError(unresolvedJwtKeyError(kid: kid, requestDid: presentationRequest.iss), completionBlock)
            return
        }
        jwtServiceRepository.verifyJwt(
            jwt: presentationRequest.jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: presentationRequest.remoteCryptoServicesToken
        ) { [weak self] jwtVerificationRes in
            do {
                let _ = try jwtVerificationRes.get()
                self?.presentationRequestByDeepLinkVerifier.verifyPresentationRequest(
                    presentationRequest: presentationRequest,
                    deepLink: presentationRequest.deepLink,
                    didDocument: didDocument
                ) { byDeepLinkVerificationRes in
                    do {
                        try byDeepLinkVerificationRes.get()
                        self?.executor.runOnMain {
                            completionBlock(.success(presentationRequest))
                        }
                    }catch {
                        self?.onError(
                            ErrorTaxonomy.classifyRequestValidation(
                                VCLError(error: error),
                                requestKind: ErrorTaxonomy.requestKindPresentation,
                                requestDid: presentationRequest.iss
                            ),
                            completionBlock
                        )
                    }
                }
            } catch {
                self?.onError(
                    ErrorTaxonomy.classifyRequestValidation(
                        VCLError(error: error),
                        requestKind: ErrorTaxonomy.requestKindPresentation,
                        requestDid: presentationRequest.iss
                    ),
                    completionBlock
                )
            }
        }
    }

    private func validateDidDocument(
        _ didDocument: VCLDidDocument,
        presentationRequest: VCLPresentationRequest
    ) -> VCLError? {
        if didDocument.payload.isEmpty || didDocument.hasVerificationMethods == false {
            return ErrorTaxonomy.classifyDidResolution(
                VCLError(message: "public jwk not found for kid"),
                requestKind: ErrorTaxonomy.requestKindPresentation,
                requestDid: presentationRequest.iss
            )
        }
        return nil
    }

    private func missingJwtKidError(requestDid: String?) -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "JWT kid is missing"),
            requestKind: ErrorTaxonomy.requestKindPresentation,
            requestDid: requestDid
        )
    }

    private func missingJwtIssError() -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "JWT iss is missing"),
            requestKind: ErrorTaxonomy.requestKindPresentation,
            requestDid: nil
        )
    }

    private func unresolvedJwtKeyError(kid: String, requestDid: String?) -> VCLError {
        ErrorTaxonomy.classifyRequestValidation(
            VCLError(message: "public jwk not found for kid: \(kid)"),
            requestKind: ErrorTaxonomy.requestKindPresentation,
            requestDid: requestDid
        )
    }

    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnMain {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
