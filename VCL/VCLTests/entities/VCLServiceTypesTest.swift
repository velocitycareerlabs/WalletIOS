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
            all: [
                VCLServiceType.Issuer,
                VCLServiceType.Inspector,
                VCLServiceType.CareerIssuer,
                VCLServiceType.NotaryIssuer,
                VCLServiceType.IdentityIssuer,
                VCLServiceType.IdDocumentIssuer,
                VCLServiceType.NotaryIdDocumentIssuer,
                VCLServiceType.ContactIssuer,
                VCLServiceType.NotaryContactIssuer
            ]
        )

        assert(serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.Inspector))
        assert(serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))

        assert(serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [
                VCLServiceType.IdentityIssuer,
                VCLServiceType.IdDocumentIssuer,
                VCLServiceType.ContactIssuer,
                VCLServiceType.Inspector,
                VCLServiceType.NotaryIssuer
            ])))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(all: [VCLServiceType.Undefined])))
    }

    func testContainsPartial() {
        let serviceTypes = VCLServiceTypes(
            all: [
                VCLServiceType.Issuer,
                VCLServiceType.Inspector,
                VCLServiceType.CareerIssuer
            ]
        )

        assert(serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.Inspector))
        assert(serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))

        assert(serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(all: [VCLServiceType.Inspector])))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(all: [
            VCLServiceType.NotaryIssuer,
            VCLServiceType.IdentityIssuer,
            VCLServiceType.IdDocumentIssuer,
            VCLServiceType.NotaryIdDocumentIssuer,
            VCLServiceType.ContactIssuer,
            VCLServiceType.NotaryContactIssuer,
            VCLServiceType.Undefined
        ])))
    }

    func testContainsEmpty() {
        let serviceTypes = VCLServiceTypes(all: [])

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Inspector))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [
                VCLServiceType.Issuer,
                VCLServiceType.Inspector,
                VCLServiceType.CareerIssuer,
                VCLServiceType.NotaryIssuer,
                VCLServiceType.IdentityIssuer,
                VCLServiceType.IdDocumentIssuer,
                VCLServiceType.NotaryIdDocumentIssuer,
                VCLServiceType.ContactIssuer,
                VCLServiceType.NotaryContactIssuer
            ])))
    }

    func testFromCareer() {
        let serviceTypes = VCLServiceTypes(issuingType: VCLIssuingType.Career)

        assert(serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))

        assert(serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [
                VCLServiceType.Inspector,
                VCLServiceType.NotaryIssuer
            ])))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(all: [
            VCLServiceType.Inspector
        ])))
    }

    func testFromIdentity() {
        let serviceTypes = VCLServiceTypes(issuingType: VCLIssuingType.Identity)

        assert(serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))

        assert(serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [
                VCLServiceType.NotaryIdDocumentIssuer,
                VCLServiceType.Inspector
            ]
        )))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))
        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [VCLServiceType.Issuer, VCLServiceType.Inspector]
        )))
    }

    func testFromRefresh() {
        let serviceTypes = VCLServiceTypes(issuingType: VCLIssuingType.Refresh)

        assert(serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.Issuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.CareerIssuer))
        assert(serviceTypes.contains(serviceType: VCLServiceType.NotaryIssuer))

        assert(serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [
                VCLServiceType.ContactIssuer,
                VCLServiceType.Inspector
            ]
            )))

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))

        assert(!serviceTypes.containsAtLeastOneOf(serviceTypes: VCLServiceTypes(
            all: [VCLServiceType.Inspector]
            )))
    }

    func testFromUndefined() {
        let serviceTypes = VCLServiceTypes(all: [VCLServiceType.Undefined])

        assert(!serviceTypes.contains(serviceType: VCLServiceType.Undefined))
    }
}
