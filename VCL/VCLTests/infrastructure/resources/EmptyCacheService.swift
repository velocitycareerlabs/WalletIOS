//
//  EmptyCacheService.swift
//  VCLTests
//
//  Created by Michael Avoyan on 20/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class EmptyCacheService: CacheService {
    func getCountries(keyUrl: String) -> Data? {
        return nil
    }
    func setCountries(keyUrl: String, value: Data) {
    }

    func getCredentialTypes(keyUrl: String) -> Data? {
        return nil
    }
    func setCredentialTypes(keyUrl: String, value: Data) {
    }

    func getCredentialTypeSchema(keyUrl: String) -> Data? {
        return nil
    }
    func setCredentialTypeSchema(keyUrl: String, value: Data) {
    }
}
