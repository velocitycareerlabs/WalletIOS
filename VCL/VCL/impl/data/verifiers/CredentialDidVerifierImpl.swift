//
//  CredentialDidVerifierImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialDidVerifierImpl: CredentialDidVerifier {
    
    let dispatcher = DispatcherImpl()
    
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        var passedCredentials = [VCLJwt]()
        var failedCredentials = [VCLJwt]()
        jwtCredentials.forEach{ [weak self] jwtCredential in
            self?.dispatcher.enter()
            if (self?.verifyCredential(jwtCredential, finalizeOffersDescriptor) == true) {
                passedCredentials.append(jwtCredential)
            } else {
                failedCredentials.append(jwtCredential)
            }
            self?.dispatcher.leave()
        }
        
        dispatcher.notify(queue: DispatchQueue.global(), execute: {
            completionBlock(
                VCLResult.success(
                    VCLJwtVerifiableCredentials(
                        passedCredentials: passedCredentials,
                        failedCredentials: failedCredentials
                    )
                ))
        })
    }
    
    private func verifyCredential(
        _ jwtCredential: VCLJwt,
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor
    ) -> Bool {
        // iss == vc.issuer.id
        return jwtCredential.payload?["iss"] as? String == finalizeOffersDescriptor.issuerId
    }
}

