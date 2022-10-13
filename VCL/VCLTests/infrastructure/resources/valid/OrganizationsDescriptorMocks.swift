//
//  VCLOrganizationsDescriptorMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class VCLOrganizationsDescriptorMocks {
    static let Filter = VCLFilter(
        did: "did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88",
        serviceTypes: [VCLServiceType.Inspector],
        credentialTypes: ["EducationDegree"]
    )
    static let Page = VCLPage(size: "1", skip: "1")
    static let Sort = [["createdAt","DESC"], ["pdatedAt", "ASC"]]
    static let Query = "Bank"
}
