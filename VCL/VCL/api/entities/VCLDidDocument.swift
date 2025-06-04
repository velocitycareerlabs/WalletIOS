//
//  VCLDidDocument.swift
//  VCL
//
//  Created by Michael Avoyan on 04/06/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public struct VCLDidDocument {
    public let payload: [String: Any]
    
    public init(payload: [String: Any]) {
        self.payload = payload
    }
    public init(payloadStr: String) {
        self.payload = payloadStr.toDictionary() ?? [:]
    }
    
    var id: String {get { payload[CodingKeys.KeyId] as? String ?? "" } }
    var alsoKnownAs: [String] { get { payload[CodingKeys.KeyAlsoKnownAs] as? [String] ?? [] } }

    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyAlsoKnownAs = "alsoKnownAs"
    }
}
