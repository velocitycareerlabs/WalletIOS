//
//  Utils.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class Utils {
    static func getCredentialType(_ jwtCredential: VCLJwt) -> String? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any])?[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? [String])?.first
    }
    
    static func getCredentialSubject(_ jwtCredential: VCLJwt) -> [String: Any]? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any])?[CredentialIssuerVerifierImpl.CodingKeys.KeyCredentialSubject] as? [String: Any])
    }
    
    static func getIdentifier(
        _ primaryOrgProp: String?,
        _ jsonObject: [String: Any]
    ) -> String? {
        if(primaryOrgProp == nil) {
            return nil
        }
        var identifier: String? = nil
        var stack = [[String: Any]]()
        stack.append(jsonObject)

        while (stack.isEmpty == false) {
            let obj = stack.remove(at: stack.count - 1)

            identifier = getPrimaryIdentifier(obj[primaryOrgProp!])
            if (identifier != nil) {
                break
            }

            obj.forEach { _, value in
                if let valueDict = value as? [String: Any] {
                    stack.append(valueDict)
                }
            }
        }
        return identifier
    }
    
    static func getPrimaryIdentifier(
        _ credentialSubject: Any?
    ) -> String? {
        if ((credentialSubject as? String)?.isEmpty == false) {
            return credentialSubject as? String
        }
        return (credentialSubject as? [String: Any])?["identifier"] as? String
            ?? (credentialSubject as? [String: Any])?["id"] as? String
    }
    
    static func offersFromJsonArray(offersJsonArray: [[String: Any]]) -> [VCLOffer] {
        var allOffers = [VCLOffer]()
        offersJsonArray.forEach { 
            allOffers.append(VCLOffer(payload: $0))
        }
        return allOffers
    }

}
