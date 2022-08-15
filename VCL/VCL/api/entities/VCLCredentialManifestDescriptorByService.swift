//
//  VCLCredentialManifestDescriptorByOrganization.swift
//  VVL
//
//  Created by Michael Avoyan on 09/08/2021.
//

import Foundation

public class VCLCredentialManifestDescriptorByService: VCLCredentialManifestDescriptor {
    public init(
        service: VCLService,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil
    ) {
        super.init(uri: service.serviceEndpoint,
                   credentialTypes: credentialTypes,
                   pushDelegate: pushDelegate)
    }
///    TODO: validate credentialTypes by services.credentialTypes
    
    public override var endpoint: String { get {
        var endpoint = self.uri
        guard let queryParams = generateQueryParams() else {
            return endpoint
        }
        if let urlComponents = URLComponents(string: uri) {
            if (urlComponents.queryItems != nil) {
                endpoint += "&"
            } else {
                endpoint += "?"
            }
            endpoint += queryParams
        } else {
            endpoint += "?\(queryParams)"
        }
        return endpoint
    }}
    
    func generateQueryParams() -> String? {
        var pCredentialTypes: String? = nil
        var pPushDelegate: String? = nil
        var pPushToken: String? = nil
                
        if let credentialTypes = self.credentialTypes {
            pCredentialTypes = "\(credentialTypes.map{ type in "\(CodingKeys.KeyCredentialTypes)=\(type.encode() ?? "")" }.joined(separator: "&"))"
        }
        if let pushUrl = self.pushDelegate?.pushUrl {
            pPushDelegate = "\(CodingKeys.KeyPushDelegatePushUrl)=\(pushUrl.encode() ?? "")"
        }
        if let pushToken = self.pushDelegate?.pushToken {
            pPushToken = "\(CodingKeys.KeyPushDelegatePushToken)=\(pushToken.encode() ?? "")"
        }
        let qParams = [
            pCredentialTypes,
            pPushDelegate,
            pPushToken
        ].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
