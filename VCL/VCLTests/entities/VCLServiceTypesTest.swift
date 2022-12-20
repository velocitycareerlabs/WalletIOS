//
//  VCLServiceTypesTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLServiceTypesTest: XCTestCase {

    func testContainsFull() {
        let serviceTypes = VCLServiceTypes(
            all:[VCLServiceType.Issuer, VCLServiceType.Inspector, VCLServiceType.TrustRoot]
        )

        assert(serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.Inspector))
        assert(serviceTypes.contains(serviceType: VCLServiceType.TrustRoot))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.NodeOperator))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.HolderAppProvider))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.CredentialAgentOperator))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))
    }

    func testContainsEmpty() {
        let serviceTypes = VCLServiceTypes(all: [VCLServiceType]())

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Inspector))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.TrustRoot))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NodeOperator))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.HolderAppProvider))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.CredentialAgentOperator))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))
    }
}
