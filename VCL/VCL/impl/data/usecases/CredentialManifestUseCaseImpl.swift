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
    private let resolveKidRepository: ResolveKidRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier
    private let executor: Executor
    
    init(
        _ credentialManifestRepository: CredentialManifestRepository,
        _ resolveKidRepository: ResolveKidRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.credentialManifestRepository = credentialManifestRepository
        self.resolveKidRepository = resolveKidRepository
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
                    self.onGetCredentialManifestSuccess(
                        VCLCredentialManifest(
                            jwt: VCLJwt(encodedJwt: try credentialManifestResult.get()),
                            vendorOriginContext: credentialManifestDescriptor.vendorOriginContext,
                            verifiedProfile: verifiedProfile,
                            deepLink: credentialManifestDescriptor.deepLink,
                            didJwk: credentialManifestDescriptor.didJwk,
                            remoteCryptoServicesToken: credentialManifestDescriptor.remoteCryptoServicesToken
                        ),
                        completionBlock
                    )
                } catch {
                    self.onError(error, completionBlock)
                }
            }
        }
    }
    
    private func onGetCredentialManifestSuccess(
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let deepLink = credentialManifest.deepLink {
            credentialManifestByDeepLinkVerifier.verifyCredentialManifest(
                credentialManifest: credentialManifest, 
                deepLink: deepLink
            ) { [weak self] isVerifiedRes in
                do {
                    VCLLog.d("Credential manifest deep link verification result: \(try isVerifiedRes.get())")
                    self?.onCredentialManifestDidVerificationSuccess(
                        credentialManifest,
                        completionBlock
                    )
                }
                catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            VCLLog.d("Deep link was not provided => nothing to verify")
            onCredentialManifestDidVerificationSuccess(
                credentialManifest,
                completionBlock
            )
        }
    }
    
    private func onCredentialManifestDidVerificationSuccess(
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let kid = credentialManifest.jwt.kid?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(kid: kid) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(
                        publicKey,
                        credentialManifest,
                        completionBlock
                    )
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            self.executor.runOnMain {
                completionBlock(.failure(VCLError(message: "Empty KeyID")))
            }
        }
    }
    
    private func onResolvePublicKeySuccess(
        _ publicJwk: VCLPublicJwk,
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.verifyJwt(
            jwt: credentialManifest.jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: credentialManifest.remoteCryptoServicesToken
        ) {
            [weak self] isVerifiedResult in
            do {
                let isVerified = try isVerifiedResult.get()
                self?.onVerificationSuccess(
                    isVerified,
                    credentialManifest,
                    completionBlock
                )
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if (isVerified) {
            executor.runOnMain {
                completionBlock(.success(credentialManifest))
            }
        } else {
            onError(
                VCLError(message: "Failed to verify credentialManifest jwt:\n\(credentialManifest.jwt)"),
                completionBlock
            )
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
