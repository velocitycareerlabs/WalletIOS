//
//  VCLOffersTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 19/06/2024.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLOffersTest: XCTestCase {
    private let subject1 = VCLOffers.fromPayload(
        payloadData: OffersMocks.OffersJsonArrayStr.toData(),
        responseCode: 123,
        sessionToken: VCLToken(value: "some token")
    )
    private let subject2 = VCLOffers.fromPayload(
        payloadData: OffersMocks.OffersJsonObjectStr.toData(),
        responseCode: 123,
        sessionToken: VCLToken(value: "some token")
    )
    private let subject3 = VCLOffers.fromPayload(
        payloadData: OffersMocks.offersJsonEmptyArrayStr.toData(),
        responseCode: 123,
        sessionToken: VCLToken(value: "some token")
    )
    private let subject4 = VCLOffers.fromPayload(
        payloadData: OffersMocks.offersJsonEmptyObjectStr.toData(),
        responseCode: 123,
        sessionToken: VCLToken(value: "some token")
    )
    
    func testOffersFromJsonArray() {
        assert(
            subject1.payload[VCLOffers.CodingKeys.KeyOffers] as! [[String: Sendable]] == OffersMocks.OffersJsonArrayStr.toListOfDictionaries()!
        )
        assert(subject1.challenge == nil)
        testExpectations(subject1)
        assert(
            subject1.all.map { $0.payload } == OffersMocks.OffersJsonArrayStr.toListOfDictionaries()!
        )
    }
    
    func testOffersFromJsonDictionary() {
        assert(
            subject2.payload[VCLOffers.CodingKeys.KeyOffers] as! [[String: Sendable]] == OffersMocks.OffersJsonArrayStr.toListOfDictionaries()!
        )
        assert(subject2.challenge == OffersMocks.challenge)
        testExpectations(subject2)
        assert(
            subject2.all.map { $0.payload } == OffersMocks.OffersJsonArrayStr.toListOfDictionaries()!
        )
    }
    
    func testOffersFromEmptyJsonArray() {
        assert(
            subject3.payload[VCLOffers.CodingKeys.KeyOffers] as! [[String: Sendable]] == OffersMocks.offersJsonEmptyArrayStr.toListOfDictionaries()!
        )
        assert(subject3.challenge == nil)
        testExpectationsEmpty(subject3)
        assert(
            subject3.all.map { $0.payload } == OffersMocks.offersJsonEmptyArrayStr.toListOfDictionaries()!
        )
    }
    
    func testOffersFromEmptyJsonObject() {
        assert(
            subject4.payload == OffersMocks.offersJsonEmptyObjectStr.toDictionary()!
        )
        assert(subject4.challenge == OffersMocks.challenge)
        testExpectationsEmpty(subject4)
        assert(
            subject4.all.map { $0.payload } == OffersMocks.offersJsonEmptyArrayStr.toListOfDictionaries()!
        )
    }
    
    private func testExpectations(_ subject: VCLOffers) {
        assert(subject.responseCode == 123)
        assert(subject.sessionToken.value == "some token")
        assert(subject.all.count == 11)
    }
    
    private func testExpectationsEmpty(_ subject: VCLOffers) {
        assert(subject.responseCode == 123)
        assert(subject.sessionToken.value == "some token")
        assert(subject.all.count == 0)
    }
}
