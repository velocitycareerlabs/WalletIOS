//
//  CommonMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 09/05/2023.
//

import Foundation
@testable import VCL

struct CommonMocks {
    static let UUID1 = "6E6B7489-13C8-45E8-A24D-0BC309B484D1"
    static let UUID2 = "6E6B7489-13C8-45E8-A24D-0BC309B484D2"
    static let UUID3 = "6E6B7489-13C8-45E8-A24D-0BC309B484D3"
    static let UUID4 = "6E6B7489-13C8-45E8-A24D-0BC309B484D4"
    static let UUID5 = "6E6B7489-13C8-45E8-A24D-0BC309B484D5"
    static let DID = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw"
    static let DidJwk = generateJwk()
    
    private static func generateJwk() -> VCLDidJwk? {
        do {
            return try JwtServiceImpl(secretStore: SecretStoreMock()).generateDidJwk(didJwkDescriptor: VCLDidJwkDescriptor(kid: UUID1))
        } catch {}
        return nil
    }
}
