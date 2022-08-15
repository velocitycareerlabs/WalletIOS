//
//  VCLService.swift
//  VCL
//
//  Created by Michael Avoyan on 18/08/2021.
//

import Foundation

public class VCLService {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    
    public var id: String { get { payload[CodingKeys.KeyId] as? String ?? "" } }
    public var type: String { get { payload[CodingKeys.KeyType] as? String ?? "" } }
    public var serviceEndpoint: String { get { payload[CodingKeys.KeyServiceEndpoint] as? String ?? "" } }
    
    enum CodingKeys {
        static let KeyId = "id"
        static let KeyType = "type"
        static let KeyCredentialTypes = "credentialTypes"
        static let KeyServiceEndpoint = "serviceEndpoint"
    }
}
