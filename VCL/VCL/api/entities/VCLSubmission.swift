//
//  VCLSubmission.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol PayloadGeneratable {
    func generatePayload(iss: String?) -> [String: Any]
}

protocol RequestBodyGeneratable {
    func generateRequestBody(jwt: VCLJwt) -> [String: Any]
}

public protocol VCLSubmission {
    var submitUri: String { get }
    var exchangeId: String { get }
    var presentationDefinitionId: String { get }
    var verifiableCredentials: [VCLVerifiableCredential]? { get }
    var pushDelegate: VCLPushDelegate? { get }
    var vendorOriginContext: String? { get }
    var didJwk: VCLDidJwk { get }
    var remoteCryptoServicesToken: VCLToken? { get }
    var jti: String { get }
    var submissionId: String { get }
}

extension VCLSubmission {
    func generatePayload(iss: String?) -> [String: Any] {
        var retVal = [String: Any]()
        retVal[SubmissionCodingKeys.KeyJti] = self.jti
        retVal[SubmissionCodingKeys.KeyIss] = iss
        var vp = [String: Any]()
        vp[SubmissionCodingKeys.KeyType] = SubmissionCodingKeys.ValueVerifiablePresentation
        var presentationSubmissionDict = [String: Any]()
        presentationSubmissionDict[SubmissionCodingKeys.KeyId] = self.submissionId
        presentationSubmissionDict[SubmissionCodingKeys.KeyDefinitionId] = presentationDefinitionId
        var descriptorMap = [[String: String]]()
        for (index, credential) in (self.verifiableCredentials ?? [VCLVerifiableCredential]()).enumerated() {
            var res = [String: String]()
            res[SubmissionCodingKeys.KeyId] = credential.inputDescriptor
            res[SubmissionCodingKeys.KeyPath] = "$.verifiableCredential[\(index)]"
            res[SubmissionCodingKeys.KeyFormat] = SubmissionCodingKeys.ValueJwtVcFormat
            descriptorMap.append(res)
        }
        vp[SubmissionCodingKeys.KeyVerifiableCredential] = self.verifiableCredentials?.map { credential in credential.jwtVc }
        presentationSubmissionDict[SubmissionCodingKeys.KeyDescriptorMap] = descriptorMap
        vp[SubmissionCodingKeys.KeyPresentationSubmission] = presentationSubmissionDict
        if let voc = vendorOriginContext {
            vp[SubmissionCodingKeys.KeyVendorOriginContext] = voc
        }
        retVal[SubmissionCodingKeys.KeyVp] = vp
        return retVal
    }

    func generateRequestBody(jwt: VCLJwt) -> [String: Any] {
        var retVal = [String: Any]()
        retVal[SubmissionCodingKeys.KeyExchangeId] = exchangeId
        retVal[SubmissionCodingKeys.KeyJwtVp] = jwt.encodedJwt
        retVal[SubmissionCodingKeys.KeyPushDelegate] = pushDelegate?.toDictionary()
        retVal[SubmissionCodingKeys.KeyContext] = SubmissionCodingKeys.ValueContextList
        return retVal
    }
}

public struct SubmissionCodingKeys {
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
    public static let KeyContext = "@context"
    public static let ValueContextList = ["https://www.w3.org/2018/credentials/v1"]
}
