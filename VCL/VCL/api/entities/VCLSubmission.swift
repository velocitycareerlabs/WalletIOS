//
//  VCLSubmission.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLSubmission {
    public let submitUri: String
    public let didJwk: VCLDidJwk
    public let iss: String
    public let exchangeId: String
    public let presentationDefinitionId: String
    public let verifiableCredentials: [VCLVerifiableCredential]
    public let pushDelegate: VCLPushDelegate?
    public let vendorOriginContext: String?
    
    public let jti = UUID().uuidString
    public let submissionId = UUID().uuidString
    
    public init(
        submitUri: String,
        didJwk: VCLDidJwk,
        iss: String,
        exchangeId: String,
        presentationDefinitionId: String,
        verifiableCredentials: [VCLVerifiableCredential],
        pushDelegate: VCLPushDelegate? = nil,
        vendorOriginContext: String? = nil
    ) {
        self.submitUri = submitUri
        self.didJwk = didJwk
        self.iss = iss
        self.exchangeId = exchangeId
        self.presentationDefinitionId = presentationDefinitionId
        self.verifiableCredentials = verifiableCredentials
        self.pushDelegate = pushDelegate
        self.vendorOriginContext = vendorOriginContext
    }
    
    public var payload: [String: Any] { get { return generatePayload() } }
    
    private func generatePayload() -> [String: Any] {
        var retVal = [String: Any]()
        retVal[CodingKeys.KeyJti] = self.jti
        var vp = [String: Any]()
        vp[CodingKeys.KeyType] = CodingKeys.ValueVerifiablePresentation
        var presentationSubmissionDict = [String: Any]()
        presentationSubmissionDict[CodingKeys.KeyId] = self.submissionId
        presentationSubmissionDict[CodingKeys.KeyDefinitionId] = presentationDefinitionId
        var descriptorMap = [[String: String]]()
        for (index, credential) in self.verifiableCredentials.enumerated() {
            var res = [String: String]()
            res[CodingKeys.KeyId] = credential.inputDescriptor
            res[CodingKeys.KeyPath] = "$.verifiableCredential[\(index)]"
            res[CodingKeys.KeyFormat] = CodingKeys.ValueJwtVcFormat
            descriptorMap.append(res)
        }
        vp[CodingKeys.KeyVerifiableCredential] = self.verifiableCredentials.map{ credential in credential.jwtVc }
        presentationSubmissionDict[CodingKeys.KeyDescriptorMap] = descriptorMap
        vp[CodingKeys.KeyPresentationSubmission] = presentationSubmissionDict
        if let voc = vendorOriginContext { vp[VCLSubmission.CodingKeys.KeyVendorOriginContext] = voc }
        retVal[CodingKeys.KeyVp] = vp
        return retVal
    }
    
    func generateRequestBody(jwt: VCLJwt) -> [String: Any] {
        var retVal = [String: Any] ()
        retVal[CodingKeys.KeyExchangeId] = exchangeId
        retVal[CodingKeys.KeyJwtVp] = jwt.encodedJwt
        retVal[CodingKeys.KeyPushDelegate] = pushDelegate?.toDictionary()
        return retVal
    }
    
    public struct CodingKeys {
        public static let KeyJti = "jti"
        public static let KeyIss = "iss"
        public static let KeyId = "id"
        public static let KeyVp = "vp"
        public static let KeyDid = "did"
        public static let KeyPushDelegate = "push_delegate"
        
        public static let KeyType = "type"
        public static let KeyPresentationSubmission = "presentation_submission"
        public static let KeyDefinitionId = "definition_id"
        public static let KeyDescriptorMap = "descriptor_map"
        public static let KeyExchangeId = "exchange_id"
        public static let KeyJwtVp = "jwt_vp"
        public static let KeyPath = "path"
        public static let KeyFormat = "format"
        public static let KeyVerifiableCredential = "verifiableCredential"
        public static let KeyVendorOriginContext = "vendorOriginContext"
        public static let KeyInputDescriptor = "input_descriptor"
        
        public static let ValueVerifiablePresentation = "VerifiablePresentation"
        public static let ValueJwtVcFormat = "jwt_vc"
    }
}
