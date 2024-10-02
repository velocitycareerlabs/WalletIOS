//
//  CacheServiceImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 20/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CacheServiceImpl: @unchecked Sendable, CacheService {
    
    private static let KEY_CACHE_SEQUENCE_COUNTRIES = "KEY_CACHE_SEQUENCE_COUNTRIES"
    private static let KEY_CACHE_SEQUENCE_CREDENTIAL_TYPES = "KEY_CACHE_SEQUENCE_CREDENTIAL_TYPES"
    private static let KEY_CACHE_SEQUENCE_CREDENTIAL_TYPE_SCHEMA = "KEY_CACHE_SEQUENCE_CREDENTIAL_TYPE_SCHEMA"

    private let defaults: UserDefaults = UserDefaults()

    private func getData(key: String) -> Data? {
        return defaults.data(forKey: key)
    }
    private func setData(key: String, value: Data) {
        defaults.set(value, forKey: key)
    }
    
    private func getInt(key: String) -> Int {
        return defaults.integer(forKey: key)
    }
    private func setInt(key: String, value: Int) {
        defaults.set(value, forKey: key)
    }
    
    func getCountries(key: String) -> Data? {
        return getData(key: key)
    }
    func setCountries(key: String, value: Data, cacheSequence: Int) {
        setData(key: key, value: value)
        setInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_COUNTRIES, value: cacheSequence)
    }
    func isResetCacheCountries(cacheSequence: Int) -> Bool {
        getInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_COUNTRIES) < cacheSequence
    }
    
    func getCredentialTypes(key: String) -> Data? {
        return getData(key: key)
    }
    func setCredentialTypes(key: String, value: Data, cacheSequence: Int) {
        setData(key: key, value: value)
        setInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_CREDENTIAL_TYPES, value: cacheSequence)
    }
    func isResetCacheCredentialTypes(cacheSequence: Int) -> Bool {
        return getInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_CREDENTIAL_TYPES) < cacheSequence
    }
    
    func getCredentialTypeSchema(key: String) -> Data? {
        return getData(key: key)
    }
    func setCredentialTypeSchema(key: String, value: Data, cacheSequence: Int) {
        setData(key: key, value: value)
        setInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_CREDENTIAL_TYPE_SCHEMA, value: cacheSequence)
    }
    func isResetCacheCredentialTypeSchema(cacheSequence: Int) -> Bool {
        return getInt(key: CacheServiceImpl.KEY_CACHE_SEQUENCE_CREDENTIAL_TYPE_SCHEMA) < cacheSequence
    }
}
