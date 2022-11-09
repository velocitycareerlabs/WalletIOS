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
    func getCountries(key: String) -> Data? { return nil }
    func setCountries(key: String, value: Data, cacheSequence: Int) {}
    func isResetCacheCountries(cacheSequence: Int) -> Bool { return false }

    func getCredentialTypes(key: String) -> Data? { return nil }
    func setCredentialTypes(key: String, value: Data, cacheSequence: Int) {}
    func isResetCacheCredentialTypes(cacheSequence: Int) -> Bool { return false }

    func getCredentialTypeSchema(key: String) -> Data? { return nil }
    func setCredentialTypeSchema(key: String, value: Data, cacheSequence: Int) {}
    func isResetCacheCredentialTypeSchema(cacheSequence: Int) -> Bool { return false }
}
