//
//  VCLCredentialManifestDescriptorRefresh.swift
//  VCL
//
//  Created by Michael Avoyan on 11/04/2022.
//

import Foundation

public class VCLCredentialManifestDescriptorRefresh: VCLCredentialManifestDescriptor {
    let service: VCLService
    let credentialIds:[String]
    
    public init(
        service: VCLService,
        credentialIds:[String]
    ) {
        self.service = service
        self.credentialIds = credentialIds
        
        super.init(uri: service.serviceEndpoint)
    }

    public override var endpoint: String { get {
        var endPoint = "\(uri)?\(CodingKeys.KeyRefresh)=\(true)"
        if let queryParams = generateQueryParams() {
            if let urlComponents = URLComponents(string: uri) {
                var allQueryParams = "?"
                if (urlComponents.queryItems != nil) {
                    allQueryParams = "&"
                }
                allQueryParams += "\(CodingKeys.KeyRefresh)=\(true)&\(queryParams)"
                endPoint = uri + allQueryParams
            }
        }
        return endPoint
    }}
    
    func generateQueryParams() -> String? {
        let pCredentialIds = "\(self.credentialIds.map{ id in "\(CodingKeys.KeyCredentialId)=\(id.encode() ?? "")" }.joined(separator: "&"))"

        let qParams = [pCredentialIds].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
