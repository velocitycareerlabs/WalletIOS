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
    ///  The implementation relaying on the below reference:
    ///  https://github.com/velocitycareerlabs/velocitycore/blob/37c8535c2ef839ed72a2706685a398f20f4ae11c/packages/vc-checks/src/extract-credential-type.js#L20
    static func getCredentialType(_ jwtCredential: VCLJwt) -> String? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: AnyHashable])?[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? [String])?.first { $0 != "VerifiableCredential" }
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
    
    internal static func extractCredentialSubjectType(from subject: [String: Any]) -> String? {
        if let types = subject[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? [Any],
           let firstType = types.first as? String {
            return firstType
        }
        return subject[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? String
    }

    internal static func extractActiveContext(
        _ completeContext: [String: Any],
        _ credentialSubjectType: String
    ) -> [String: Any] {
        let nested = (completeContext[CredentialIssuerVerifierImpl.CodingKeys.KeyContext] as? [String: Any])?[credentialSubjectType] as? [String: Any]
        return nested?[CredentialIssuerVerifierImpl.CodingKeys.KeyContext] as? [String: Any] ?? completeContext
    }
    
    internal static func findKeyForPrimaryOrganizationValue(
        _ activeContext: [String: Any]
    ) -> String? {
        for (key, value) in activeContext {
            if let valueMap = value as? [String: Any] {
                let id = valueMap[CredentialIssuerVerifierImpl.CodingKeys.KeyId] as? String
                if (id == CredentialIssuerVerifierImpl.CodingKeys.ValPrimaryOrganization || id == CredentialIssuerVerifierImpl.CodingKeys.ValPrimarySourceProfile) {
                    return key
                }
            }
        }
        return nil
    }
}
