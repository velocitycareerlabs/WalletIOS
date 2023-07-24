//
//  CredentialDidVerifierImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialDidVerifierImpl: CredentialDidVerifier {
    private let dispatcher: Dispatcher
    
    init(_ dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
    }
    
    func verifyCredentials(
        jwtEncodedCredentials: [String],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        var passedCredentials = [VCLJwt]()
        var failedCredentials = [VCLJwt]()
                
        jwtEncodedCredentials.forEach{ [weak self] jwtCredential in
            self?.dispatcher.enter()
            let jwtCredential = VCLJwt(encodedJwt: jwtCredential)
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
        return jwtCredential.payload?["iss"] as? String == finalizeOffersDescriptor.did
    }
}

