//
//  SecretStoreMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/04/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCCrypto

enum SecretStoreMockError: Error {
    case noKeyFound
}

internal class SecretStoreMock: SecretStoring {
    
    public static let Instance = SecretStoreMock()
    
    var memoryStore = [UUID: Data]()
    
    static var wasGetSecretCalled = false
    
    static var wasSaveSecretCalled = false
    
    static var wasDeleteSecretCalled = false
    
    let testInputCallback: ((String?, String?) -> ())?
    
    private init(testInputCallback: ((String?, String?) -> ())? = nil) {
        self.testInputCallback = testInputCallback
    }
    
    func getSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws -> Data {
        Self.wasGetSecretCalled = true
        testInputCallback?(itemTypeCode, accessGroup)
        if let secret = memoryStore[id] {
            return secret
        }
        
        throw SecretStoreMockError.noKeyFound
    }
    
    func saveSecret(id: UUID, itemTypeCode: String, accessGroup: String?, value: inout Data) throws {
        Self.wasSaveSecretCalled = true
        testInputCallback?(itemTypeCode, accessGroup)
        memoryStore[id] = value
    }
    
    func deleteSecret(id: UUID, itemTypeCode: String, accessGroup: String?) throws {
        Self.wasDeleteSecretCalled = true
        testInputCallback?(itemTypeCode, accessGroup)
        memoryStore.removeValue(forKey: id)
    }
    
}
