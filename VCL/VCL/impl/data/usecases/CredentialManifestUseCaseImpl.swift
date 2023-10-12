//
//  CredentialManifestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialManifestUseCaseImpl: CredentialManifestUseCase {
    
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
    
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.credentialManifestRepository.getCredentialManifest(
                credentialManifestDescriptor: credentialManifestDescriptor
            ) {
                credentialManifestResult in
                do {
                    self?.ongetCredentialManifestSuccess(
                        VCLJwt(encodedJwt: try credentialManifestResult.get()),
                        credentialManifestDescriptor,
                        verifiedProfile,
                        remoteCryptoServicesToken,
                        completionBlock
                    )
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        }
    }
    
    private func ongetCredentialManifestSuccess(
        _ jwt: VCLJwt,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ verifiedProfile: VCLVerifiedProfile,
        _ remoteCryptoServicesToken: VCLToken?,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let kid = jwt.kid?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(kid: kid) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(
                        publicKey,
                        jwt,
                        credentialManifestDescriptor,
                        verifiedProfile,
                        remoteCryptoServicesToken,
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
        _ jwt: VCLJwt,
        _ credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        _ verifiedProfile: VCLVerifiedProfile,
        _ remoteCryptoServicesToken: VCLToken?,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.verifyJwt(
            jwt: jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken
        ) {
            [weak self] isVerifiedResult in
            do {
                let isVerified = try isVerifiedResult.get()
                self?.onVerificationSuccess(
                    isVerified,
                    jwt,
                    credentialManifestDescriptor,
                    verifiedProfile,
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
        _ verifiedProfile: VCLVerifiedProfile,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if isVerified == true {
            executor.runOnMain { completionBlock(.success(
                VCLCredentialManifest(
                    jwt: jwt,
                    vendorOriginContext: credentialManifestDescriptor.vendorOriginContext,
                    verifiedProfile: verifiedProfile
                )))
            }
        } else {
            executor.runOnMain {
                completionBlock(.failure(VCLError(message: "Failed  to verify: \(jwt)")))
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
