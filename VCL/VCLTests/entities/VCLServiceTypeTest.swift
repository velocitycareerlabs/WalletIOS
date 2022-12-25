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
        assert(VCLServiceType.fromString(value: "TrustRoot") == VCLServiceType.TrustRoot)
        assert(VCLServiceType.fromString(value: "CareerIssuer") == VCLServiceType.CareerIssuer)
        assert(VCLServiceType.fromString(value: "NodeOperator") == VCLServiceType.NodeOperator)
        assert(VCLServiceType.fromString(value: "NotaryIssuer") == VCLServiceType.NotaryIssuer)
        assert(VCLServiceType.fromString(value: "IdentityIssuer") == VCLServiceType.IdentityIssuer)
        assert(VCLServiceType.fromString(value: "HolderAppProvider") == VCLServiceType.HolderAppProvider)
        assert(VCLServiceType.fromString(value: "CredentialAgentOperator") == VCLServiceType.CredentialAgentOperator)
        assert(VCLServiceType.fromString(value: "OtherService") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "Undefined") == VCLServiceType.Undefined)
    }
    
    func testFromNonExactString() {
        assert(VCLServiceType.fromString(value: "11_Issuer6_2") == VCLServiceType.Issuer)
        assert(VCLServiceType.fromString(value: "hyre_8Inspector09_nf") == VCLServiceType.Inspector)
        assert(VCLServiceType.fromString(value: "98-dTrustRoot") == VCLServiceType.TrustRoot)
        assert(VCLServiceType.fromString(value: "9jfCareerIssuer@#$%") == VCLServiceType.CareerIssuer)
        assert(VCLServiceType.fromString(value: "nuew&jNodeOperator#9^5") == VCLServiceType.NodeOperator)
        assert(VCLServiceType.fromString(value: ")64fhsNotaryIssuer") == VCLServiceType.NotaryIssuer)
        assert(VCLServiceType.fromString(value: "IdentityIssuer05%#Rg&*") == VCLServiceType.IdentityIssuer)
        assert(VCLServiceType.fromString(value: "[w]D[pw}{QHolderAppProvider$FJS294F}") == VCLServiceType.HolderAppProvider)
        assert(VCLServiceType.fromString(value: "CredentialAgentOperator)$Ffhs@") == VCLServiceType.CredentialAgentOperator)
        assert(VCLServiceType.fromString(value: "ksdjhkD#OtherService959)%") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "#Wfg85$Undefined)%dgsc") == VCLServiceType.Undefined)
        assert(VCLServiceType.fromString(value: "") == VCLServiceType.Undefined)
    }
}
