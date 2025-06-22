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
                do {
                    let presentationRequest = VCLPresentationRequest(
                        jwt: VCLJwt(encodedJwt: try encodedJwtStrResult.get()),
                        verifiedProfile: verifiedProfile,
                        deepLink: presentationRequestDescriptor.deepLink,
                        pushDelegate: presentationRequestDescriptor.pushDelegate,
                        didJwk: presentationRequestDescriptor.didJwk,
                        remoteCryptoServicesToken: presentationRequestDescriptor.remoteCryptoServicesToken
                    )
                    self?.resolveDidDocumentRepository.resolveDidDocument(
                        did: presentationRequest.iss
                    ) { didDocumentResult in
                        do {
                            let didDocument = try didDocumentResult.get()
                            if let publicJwk = didDocument.getPublicJwk(kid: presentationRequest.jwt.kid ?? "") {
                                self?.verifyPresentationRequest(
                                    publicJwk,
                                    presentationRequest,
                                    didDocument,
                                    completionBlock
                                )
                            } else {
                                self?.onError(
                                    VCLError(error: "public jwk not found for kid: \(presentationRequest.jwt.kid ?? "")"),
                                    completionBlock
                                )
                            }
                        } catch {
                            self?.onError(VCLError(error: error), completionBlock)
                        }
                    }
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        }
    }
    
    private func verifyPresentationRequest(
        _ publicJwk: VCLPublicJwk,
        _ presentationRequest: VCLPresentationRequest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
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
                        let isVerified = try byDeepLinkVerificationRes.get()
                        VCLLog.d("Presentation request by deep link verification result: \(isVerified)")
                        self?.onVerificationSuccess(
                            isVerified,
                            presentationRequest,
                            completionBlock
                        )
                    }catch {
                        self?.onError(error, completionBlock)
                    }
                }
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        if isVerified == true {
            executor.runOnMain {
                completionBlock(.success(presentationRequest))
            }
        } else {
            onError(VCLError(message: "Failed  to verify: \(presentationRequest.jwt.payload ?? [:])"), completionBlock)
        }
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
