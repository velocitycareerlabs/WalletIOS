//
//  CredentialManifestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CredentialManifestUseCaseImpl: CredentialManifestUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!

    private let credentialManifestRepository: CredentialManifestRepository
    private let resolveKidRepository: ResolveKidRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(_ credentialManifestRepository: CredentialManifestRepository,
         _ resolveKidRepository: ResolveKidRepository,
         _ jwtServiceRepository: JwtServiceRepository,
         _ executor: Executor) {
        self.credentialManifestRepository = credentialManifestRepository
        self.resolveKidRepository = resolveKidRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func getCredentialManifest(credentialManifestDescriptor: VCLCredentialManifestDescriptor,
                               completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void) {
        executor.runOnBackgroundThread() { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(CredentialManifestUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                self?.credentialManifestRepository.getCredentialManifest(
                    credentialManifestDescriptor: credentialManifestDescriptor
                ) {
                    jwtStrResult in
                    do {
                        let jwtStr = try jwtStrResult.get()
                        _self.onGetJwtSuccess(
                            jwtStr,
                            credentialManifestDescriptor,
                            completionBlock
                        )
                    } catch {
                        _self.onError(error, completionBlock)
                    }
                }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
    
    private func onGetJwtSuccess(
        _ jwtStr: String,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.decode(encodedJwt: jwtStr) {
            [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                self?.onDecodeJwtSuccess(
                    jwt,
                    credentialManifestDescriptor,
                    completionBlock
                )
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onDecodeJwtSuccess(
        _ jwt: VCLJwt,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let keyID = jwt.keyId?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(keyID: keyID) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(
                        publicKey,
                        jwt,
                        credentialManifestDescriptor,
                        completionBlock
                    )
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            self.executor.runOnMainThread {
                completionBlock(.failure(VCLError(message: "Empty KeyID")))
            }
        }
    }
    
    private func onResolvePublicKeySuccess(
        _ jwkPublic: VCLJwkPublic,
        _ jwt: VCLJwt,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.verifyJwt(jwt: jwt, jwkPublic: jwkPublic) {
            [weak self] isVerifiedResult in
            do {
                let isVerified = try isVerifiedResult.get()
                self?.onVerificationSuccess(
                    isVerified,
                    jwt,
                    credentialManifestDescriptor,
                    completionBlock
                )
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ jwt: VCLJwt,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if isVerified == true {
            executor.runOnMainThread { completionBlock(.success(
                VCLCredentialManifest(
                    jwt: jwt,
                    vendorOriginContext: credentialManifestDescriptor.vendorOriginContext
                )))
            }
        } else {
            executor.runOnMainThread {
                completionBlock(.failure(VCLError(message: "Failed  to verify: \(jwt)")))
            }
        }
    }
    
    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnMainThread {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
