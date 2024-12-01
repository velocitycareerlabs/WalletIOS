//
//  VerificationUtils.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VerificationUtils {
    static func getCredentialType(_ jwtCredential: VCLJwt) -> String? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: AnyHashable])?[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? [String])?.first
    }
    
    internal static func getCredentialSubjectFromCredential(_ jwtCredential: VCLJwt) -> [String: Any]? {
        return getCredentialSubjectFromPayload(credentialPayload: jwtCredential.payload)
    }

    internal static func getContextsFromCredential(_ jwtCredential: VCLJwt) -> [String]? {
        guard let credentialPayloadJson = jwtCredential.payload else {
            return nil
        }

        let rootContextsList = getContextsFromPayload(map: credentialPayloadJson[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any])
        let credentialSubjectContextsList = getContextsFromPayload(map: getCredentialSubjectFromPayload(credentialPayload: credentialPayloadJson))

        if rootContextsList == nil && credentialSubjectContextsList == nil {
            return nil
        }

        let rootContexts = rootContextsList as? [String] ?? []
        let credentialSubjectContexts = credentialSubjectContextsList as? [String] ?? []

        return Array(merge(rootContexts, credentialSubjectContexts))
    }


    private static func getCredentialSubjectFromPayload(credentialPayload: [String: Any]?) -> [String: Any]? {
        guard let vcMap = credentialPayload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any],
              let credentialSubject = vcMap[CredentialIssuerVerifierImpl.CodingKeys.KeyCredentialSubject] as? [String: Any] else {
            return nil
        }
        return credentialSubject
    }
    
    private static func getContextsFromPayload(map: [String: Any]?) -> [Any]? {
        if let credentialSubjectContexts = map?[CredentialIssuerVerifierImpl.CodingKeys.KeyContext] as? [Any] {
            return credentialSubjectContexts
        }
        if let credentialSubjectContext = map?[CredentialIssuerVerifierImpl.CodingKeys.KeyContext] as? String {
            return [credentialSubjectContext]
        }
        return nil
    }

    
    internal static func getIdentifier(
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
    
    internal static func getPrimaryIdentifier(
        _ credentialSubject: Any?
    ) -> String? {
        if ((credentialSubject as? String)?.isEmpty == false) {
            return credentialSubject as? String
        }
        return (credentialSubject as? [String: Any])?["identifier"] as? String
        ?? (credentialSubject as? [String: Any])?["id"] as? String
    }
    
    internal static func offersFromJsonArray(offersJsonArray: [[String: Any]]) -> [VCLOffer] {
        var allOffers = [VCLOffer]()
        offersJsonArray.forEach {
            allOffers.append(VCLOffer(payload: $0))
        }
        return allOffers
    }
    
    internal static func getCredentialIssuerId(jwtCredential: VCLJwt) -> String? {
        let vc: [String: Any]? = jwtCredential.payload?["vc"] as? [String: Any]
        return (vc?["issuer"] as? [String: Any])?["id"] as? String ?? vc?["issuer"] as? String
    }
}
