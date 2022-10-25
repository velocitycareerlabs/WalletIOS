//
//  CacheServiceImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 20/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CacheServiceImpl: CacheService {

    private var defaults: UserDefaults = UserDefaults()

    private func getData(key: String) -> Data? {
        return defaults.data(forKey: key)
    }
    private func setData(key: String, value: Data) {
        defaults.set(value, forKey: key)
    }
    
    func getCountries(keyUrl: String) -> Data? {
        return getData(key: keyUrl)
    }
    func setCountries(keyUrl: String, value: Data) {
        setData(key: keyUrl, value: value)
    }

    func getCredentialTypes(keyUrl: String) -> Data? {
        return getData(key: keyUrl)
    }
    func setCredentialTypes(keyUrl: String, value: Data) {
        setData(key: keyUrl, value: value)
    }
    
    func getCredentialTypeSchema(keyUrl: String) -> Data? {
        return getData(key: keyUrl)
    }
    func setCredentialTypeSchema(keyUrl: String, value: Data) {
        setData(key: keyUrl, value: value)
    }
}
