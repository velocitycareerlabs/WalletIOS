//
//  CacheService.swift
//  VCL
//
//  Created by Michael Avoyan on 20/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CacheService {
    func getCountries(key: String) -> Data?
    func setCountries(key: String, value: Data, cacheSequence: Int)
    func isResetCacheCountries(cacheSequence: Int) -> Bool

    func getCredentialTypes(key: String) -> Data?
    func setCredentialTypes(key: String, value: Data, cacheSequence: Int)
    func isResetCacheCredentialTypes(cacheSequence: Int) -> Bool

    func getCredentialTypeSchema(key: String) -> Data?
    func setCredentialTypeSchema(key: String, value: Data, cacheSequence: Int)
    func isResetCacheCredentialTypeSchema(cacheSequence: Int) -> Bool
}
