//
//  CredentialManifestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//

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
    
    func getCredentialManifest(credentialManifestDescriptor: VCLCredentialManifestDescriptor,
                               completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void) {
        executor.runOnBackgroundThread() { [weak self] in
            self?.credentialManifestRepository.getCredentialManifest(credentialManifestDescriptor: credentialManifestDescriptor) {
                jwtStrResult in
                do {
                    let jwtStr = try jwtStrResult.get()
                    self?.onGetJwtSuccess(jwtStr,completionBlock)
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        }
    }
    
    private func onGetJwtSuccess(
        _ jwtStr: String,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.decode(encodedJwt: jwtStr) {
            [weak self] jwtResult in
            do {
                let jwt = try jwtResult.get()
                self?.onDecodeJwtSuccess(jwt, completionBlock)
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onDecodeJwtSuccess(
        _ jwt: VCLJWT,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let keyID = jwt.keyID?.replacingOccurrences(of: "#", with: "#".encode() ?? "") {
            self.resolveKidRepository.getPublicKey(keyID: keyID) {
                [weak self] publicKeyResult in
                do {
                    let publicKey = try publicKeyResult.get()
                    self?.onResolvePublicKeySuccess(publicKey, jwt, completionBlock)
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            self.executor.runOnMainThread {
                completionBlock(.failure(VCLError(description: "Empty KeyID")))
            }
        }
    }
    
    private func onResolvePublicKeySuccess(
        _ publicKey: VCLPublicKey,
        _ jwt: VCLJWT,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        self.jwtServiceRepository.verifyJwt(jwt: jwt, publicKey: publicKey) {
            [weak self] isVerifiedResult in
            do {
                let isVerified = try isVerifiedResult.get()
                self?.onVerificationSuccess(isVerified, jwt, completionBlock)
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ jwt: VCLJWT,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if isVerified == true {
            executor.runOnMainThread { completionBlock(.success(VCLCredentialManifest(jwt: jwt))) }
        } else {
            executor.runOnMainThread {
                completionBlock(.failure(VCLError(description: "Failed  to verify: \(jwt)")))
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
