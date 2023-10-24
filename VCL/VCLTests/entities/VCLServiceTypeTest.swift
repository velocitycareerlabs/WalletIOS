//
//  VCLServiceTypeTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLServiceTypeTest: XCTestCase {
    
    func testFromExactString() {
        assert(VCLServiceType.fromString(value: "Issuer") == VCLServiceType.Issuer)
        assert(VCLServiceType.fromString(value: "Inspector") == VCLServiceType.Inspector)
        assert(VCLServiceType.fromString(value: "CareerIssuer") == VCLServiceType.CareerIssuer)
        assert(VCLServiceType.fromString(value: "NotaryIssuer") == VCLServiceType.NotaryIssuer)
        assert(VCLServiceType.fromString(value: "IdentityIssuer") == VCLServiceType.IdentityIssuer)
        assert(VCLServiceType.fromString(value: "IdDocumentIssuer") == VCLServiceType.IdDocumentIssuer)
        assert(VCLServiceType.fromString(value: "NotaryIdDocumentIssuer") == VCLServiceType.NotaryIdDocumentIssuer)
        assert(VCLServiceType.fromString(value: "ContactIssuer") == VCLServiceType.ContactIssuer)
        assert(VCLServiceType.fromString(value: "NotaryContactIssuer") == VCLServiceType.NotaryContactIssuer)
        assert(VCLServiceType.fromString(value: "OtherService") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "Undefined") == VCLServiceType.Undefined)
    }
    
    func testFromNonExactString() {
        assert(VCLServiceType.fromString(value: "11_Issuer6_2") == VCLServiceType.Issuer)
        assert(VCLServiceType.fromString(value: "hyre_8Inspector09_nf") == VCLServiceType.Inspector)
        assert(VCLServiceType.fromString(value: "9jfCareerIssuer@#$%") == VCLServiceType.CareerIssuer)
        assert(VCLServiceType.fromString(value: ")64fhsNotaryIssuer") == VCLServiceType.NotaryIssuer)
        assert(VCLServiceType.fromString(value: "IdentityIssuer05%#Rg&*") == VCLServiceType.IdentityIssuer)
        assert(VCLServiceType.fromString(value: "IdDocumentIssuer05%#Rg&*") == VCLServiceType.IdDocumentIssuer)
        assert(VCLServiceType.fromString(value: "NotaryIdDocumentIssuer05%#Rg&*") == VCLServiceType.NotaryIdDocumentIssuer)
        assert(VCLServiceType.fromString(value: "ContactIssuer05%#Rg&*") == VCLServiceType.ContactIssuer)
        assert(VCLServiceType.fromString(value: "NotaryContactIssuer05%#Rg&*") == VCLServiceType.NotaryContactIssuer)
        assert(VCLServiceType.fromString(value: "ksdjhkD#OtherService959)%") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "#Wfg85$Undefined)%dgsc") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "") == VCLServiceType.Undefined)
    }
}
