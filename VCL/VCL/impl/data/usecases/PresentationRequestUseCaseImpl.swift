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
    private let resolveKidRepository: ResolveKidRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let presentationRequestByDeepLinkVerifier: PresentationRequestByDeepLinkVerifier
    private let executor: Executor
    
    init(
        _ presentationRequestRepository: PresentationRequestRepository,
        _ resolveKidRepository: ResolveKidRepository,
        _ verifyRepository: JwtServiceRepository,
        _ presentationRequestByDeepLinkVerifier: PresentationRequestByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.presentationRequestRepository = presentationRequestRepository
        self.resolveKidRepository = resolveKidRepository
        self.jwtServiceRepository = verifyRepository
        self.presentationRequestByDeepLinkVerifier = presentationRequestByDeepLinkVerifier
        self.executor = executor
    }
    
    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            guard let self = self else { return }
            self.presentationRequestRepository.getPresentationRequest(
                presentationRequestDescriptor: presentationRequestDescriptor
            ) { encodedJwtStrResult in
                do {
                    self.onGetPresentationRequestSuccess(
                        VCLPresentationRequest(
                            jwt: VCLJwt(encodedJwt: try encodedJwtStrResult.get()),
                            verifiedProfile: verifiedProfile,
                            deepLink: presentationRequestDescriptor.deepLink,
                            pushDelegate: presentationRequestDescriptor.pushDelegate,
                            didJwk: presentationRequestDescriptor.didJwk,
                            remoteCryptoServicesToken: presentationRequestDescriptor.remoteCryptoServicesToken
                        ),
                        completionBlock
                    )
                } catch {
                    self.onError(VCLError(error: error), completionBlock)
                }
            }
        }
    }
    
    private func onGetPresentationRequestSuccess(
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        if let kid = presentationRequest.jwt.kid?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(kid: kid) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(
                        publicKey,
                        presentationRequest,
                        completionBlock
                    )
                }
                catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        } else {
            self.onError(VCLError(message: "Empty KeyID"), completionBlock)
        }
    }
    
    private func onResolvePublicKeySuccess(
        _ publicJwk: VCLPublicJwk,
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        self.jwtServiceRepository.verifyJwt(
            jwt: presentationRequest.jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: presentationRequest.remoteCryptoServicesToken
        ) {
            [weak self] jwtVerificationRes in
            guard let self = self else { return }
            do {
                _ = try jwtVerificationRes.get()
                self.presentationRequestByDeepLinkVerifier.verifyPresentationRequest(
                    presentationRequest: presentationRequest,
                    deepLink: presentationRequest.deepLink
                ) { byDeepLinkVerificationRes in
                    do {
                        let isVerified = try byDeepLinkVerificationRes.get()
                        VCLLog.d("Presentation request by deep link verification result: \(isVerified)")
                        self.onVerificationSuccess(
                            isVerified,
                            presentationRequest,
                            completionBlock
                        )
                    } catch {
                        self.onError(error, completionBlock)
                    }
                }
            } catch {
                self.onError(error, completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
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
        _ completionBlock: @escaping @Sendable (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnMain {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
