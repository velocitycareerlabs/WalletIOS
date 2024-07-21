//
//  CommonMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 09/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

struct CommonMocks {
    static let UUID1 = "6E6B7489-13C8-45E8-A24D-0BC309B484D1"
    static let UUID2 = "6E6B7489-13C8-45E8-A24D-0BC309B484D2"
    static let UUID3 = "6E6B7489-13C8-45E8-A24D-0BC309B484D3"
    static let UUID4 = "6E6B7489-13C8-45E8-A24D-0BC309B484D4"
    static let UUID5 = "6E6B7489-13C8-45E8-A24D-0BC309B484D5"
    static let DID1 = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvh1"
    static let DID2 = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvh2"
    static let DID3 = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvh3"
    static let DID4 = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvh4"
    static let DID5 = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvh5"
    
    static let JWT = VCLJwt(encodedJwt: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c")
    
    static let Token = VCLToken(value: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c")
}
