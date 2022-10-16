//
//  CredentialTypesMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 04/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialTypesMocks {
    static let CredentialType1 = "{\"credentialType\":\"EducationDegree\",\"schemaName\":\"education-degree\",\"recommended\":false,\"id\":\"5fe4a315d8b45dd2e80bd739\",\"createdAt\":\"2022-03-17T09:24:38.448Z\",\"updatedAt\":\"2022-03-17T09:24:38.448Z\"}"
    static let CredentialType2 = "{\"credentialType\":\"CurrentEmploymentPosition\",\"schemaName\":\"current-employment-position\",\"recommended\":true,\"id\":\"5fe4a315d8b45dd2e80bd73a\",\"createdAt\":\"2022-03-17T09:24:38.448Z\",\"updatedAt\":\"2022-03-17T09:24:38.448Z\"}"
    static let CredentialType3 = "{\"credentialType\":\"PastEmploymentPosition\",\"schemaName\":\"past-employment-position\",\"recommended\":false,\"id\":\"5fe4a315d8b45dd2e80bd73b\",\"createdAt\":\"2022-03-17T09:24:38.448Z\",\"updatedAt\":\"2022-03-17T09:24:38.448Z\"}"
    static let CredentialTypesJson = "[\(CredentialType1), \(CredentialType2), \(CredentialType3)]"
}
