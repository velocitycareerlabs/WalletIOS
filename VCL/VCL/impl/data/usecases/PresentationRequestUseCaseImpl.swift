//
//  PresentationRequestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 02/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class PresentationRequestUseCaseImpl: PresentationRequestUseCase {
    
    private let presentationRequestRepository: PresentationRequestRepository
    private let resolveKidRepository: ResolveKidRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(_ presentationRequestRepository: PresentationRequestRepository,
         _ resolveKidRepository: ResolveKidRepository,
         _ verifyRepository: JwtServiceRepository,
         _ executor: Executor) {
        self.presentationRequestRepository = presentationRequestRepository
        self.resolveKidRepository = resolveKidRepository
        self.jwtServiceRepository = verifyRepository
        self.executor = executor
    }
    
    func getPresentationRequest(
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            self?.presentationRequestRepository.getPresentationRequest(deepLink: deepLink) { encodedJwtStrResult in
                do {
                    let encodedJwtStr = try encodedJwtStrResult.get()
                    self?.onGetJwtSuccess(encodedJwtStr, deepLink, completionBlock)
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        }
    }
    
    private func onGetJwtSuccess(
        _ encodedJwtStr: String,
        _ deepLink: VCLDeepLink,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        self.jwtServiceRepository.decode(encodedJwt: encodedJwtStr) { [weak self] signedJwtResult in
            do {
                let jwt = try signedJwtResult.get()
                self?.onDecodeJwtSuccess(
                    jwt,
                    deepLink,
                    completionBlock
                )
            } catch {
                self?.onError(VCLError(error: error), completionBlock)
            }
        }
    }
    
    private func onDecodeJwtSuccess(
        _ jwt: VCLJWT,
        _ deepLink: VCLDeepLink,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        if let keyID = jwt.keyID?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(keyID: keyID) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(
                        publicKey,
                        jwt,
                        deepLink,
                        completionBlock
                    )
                }
                catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        } else {
            self.onError(VCLError(description: "Empty KeyID"), completionBlock)
        }
    }
    
    private func onResolvePublicKeySuccess(
        _ publicKey: VCLPublicKey,
        _ jwt: VCLJWT,
        _ deepLink: VCLDeepLink,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        let presentationRequest = VCLPresentationRequest(jwt: jwt, publicKey: publicKey, deepLink: deepLink)
        self.jwtServiceRepository.verifyJwt(
            jwt: presentationRequest.jwt,
            publicKey: presentationRequest.publicKey
        ) {
            [weak self] isVerifiedResult in
            do {
                let isVerified = try isVerifiedResult.get()
                self?.onVerificationSuccess(
                    isVerified,
                    presentationRequest,
                    completionBlock
                )
            } catch {
                self?.onError(VCLError(error: error), completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ presentationRequest: VCLPresentationRequest,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        if isVerified == true {
            executor.runOnMainThread {
                completionBlock(.success(presentationRequest))
            }
        } else {
            onError(VCLError(description: "Failed  to verify: \(presentationRequest.jwt.payload ?? [:])"), completionBlock)
        }
    }
    
    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnMainThread {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
