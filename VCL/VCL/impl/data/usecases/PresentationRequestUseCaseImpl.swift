//
//  PresentationRequestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 02/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class PresentationRequestUseCaseImpl: PresentationRequestUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!

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
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(PresentationRequestUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.presentationRequestRepository.getPresentationRequest(
                    presentationRequestDescriptor: presentationRequestDescriptor
                ) { encodedJwtStrResult in
                    do {
                        let encodedJwtStr = try encodedJwtStrResult.get()
                        _self.onGetJwtSuccess(encodedJwtStr, presentationRequestDescriptor, completionBlock)
                    } catch {
                        _self.onError(VCLError(error: error), completionBlock)
                    }
                }
                
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(description: "self is nil")))
            }
        }
    }
    
    private func onGetJwtSuccess(
        _ encodedJwtStr: String,
        _ presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        self.jwtServiceRepository.decode(encodedJwt: encodedJwtStr) { [weak self] signedJwtResult in
            do {
                let jwt = try signedJwtResult.get()
                self?.onDecodeJwtSuccess(
                    jwt,
                    presentationRequestDescriptor,
                    completionBlock
                )
            } catch {
                self?.onError(VCLError(error: error), completionBlock)
            }
        }
    }
    
    private func onDecodeJwtSuccess(
        _ jwt: VCLJwt,
        _ presentationRequestDescriptor: VCLPresentationRequestDescriptor,
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
                        presentationRequestDescriptor,
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
        _ jwkPublic: VCLJwkPublic,
        _ jwt: VCLJwt,
        _ presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void
    ) {
        let presentationRequest = VCLPresentationRequest(
            jwt: jwt,
            jwkPublic: jwkPublic,
            deepLink: presentationRequestDescriptor.deepLink,
            pushDelegate: presentationRequestDescriptor.pushDelegate
        )
        self.jwtServiceRepository.verifyJwt(
            jwt: presentationRequest.jwt,
            jwkPublic: presentationRequest.jwkPublic
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
            onError(VCLError(message: "Failed  to verify: \(presentationRequest.jwt.payload ?? [:])"), completionBlock)
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
