//
//  GenerateOffersMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class GenerateOffersMocks {
    static let Offers = "[{\"offer1\":\"some offer 1\"},{\"offer2\":\"some offer 2\"}]"
    static let Challenge = "CSASLD10103aa_RW"
    static let GeneratedOffers = "{\"offers\": \(Offers), \"challenge\": \(Challenge)"
    static let GeneratedOffersEmptyJsonObj = "{}"
    static let GeneratedOffersEmptyJsonArr = "[]"
}
