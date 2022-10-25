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
    func getCountries(keyUrl: String) -> Data?
    func setCountries(keyUrl: String, value: Data)

    func getCredentialTypes(keyUrl: String) -> Data?
    func setCredentialTypes(keyUrl: String, value: Data)

    func getCredentialTypeSchema(keyUrl: String) -> Data?
    func setCredentialTypeSchema(keyUrl: String, value: Data)
}
