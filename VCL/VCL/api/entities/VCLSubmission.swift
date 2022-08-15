//
//  VCLSubmission.swift
//  VCL
//
//  Created by Michael Avoyan on 09/08/2021.
//

import Foundation

public class VCLSubmission {
    public let submitUri: String
    public let iss: String
    public let exchangeId: String
    public let presentationDefinitionId: String
    public let verifiableCredentials: [VCLVerifiableCredential]
    public let vendorOriginContext: String?
    
    public init(submitUri: String,
                iss: String,
                exchangeId: String,
                presentationDefinitionId: String,
                verifiableCredentials: [VCLVerifiableCredential],
                vendorOriginContext: String? = nil) {
        self.submitUri = submitUri
        self.iss = iss
        self.exchangeId = exchangeId
        self.presentationDefinitionId = presentationDefinitionId
        self.verifiableCredentials = verifiableCredentials
        self.vendorOriginContext = vendorOriginContext
    }
    
    var payload: [String: Any] { get {
        generatePayload()
    } }
    
    private func generatePayload() -> [String: Any] {
        var retVal = [String: Any]()
        retVal[CodingKeys.KeyId] = UUID().uuidString
        var vp = [String: Any]()
        vp[CodingKeys.KeyType] = CodingKeys.ValueVerifiablePresentation
        var presentationSubmissionDict = [String: Any]()
        presentationSubmissionDict[CodingKeys.KeyId] = UUID().uuidString
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
    
    struct CodingKeys {
        static let KeyJti = "jti"
        static let KeyId = "id"
        static let KeyVp = "vp"
        static let KeyDid = "did"
        static let KeyType = "type"
        static let KeyPresentationSubmission = "presentation_submission"
        static let KeyDefinitionId = "definition_id"
        static let KeyDescriptorMap = "descriptor_map"
        static let KeyExchangeId = "exchange_id"
        static let KeyJwtVp = "jwt_vp"
        static let KeyPath = "path"
        static let KeyFormat = "format"
        static let KeyVerifiableCredential = "verifiableCredential"
        static let KeyVendorOriginContext = "vendorOriginContext"
        static let KeyInputDescriptor = "input_descriptor"
        
        static let ValueVerifiablePresentation = "VerifiablePresentation"
        static let ValueJwtVcFormat = "jwt_vc"
    }
}
