//
//  VCLOffers.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOffers {
    public let payload: [String: Any]
    public let all: [VCLOffer]
    public let responseCode: Int
    public let sessionToken: VCLToken
    public let challenge: String?
    
    public init(
        payload: [String: Any],
        all: [VCLOffer],
        responseCode: Int,
        sessionToken: VCLToken,
        challenge: String? = nil
    ) {
        self.payload = payload
        self.all = all
        self.responseCode = responseCode
        self.sessionToken = sessionToken
        self.challenge = challenge
    }
    
    public static func fromPayload(
        payloadData: Data,
        responseCode: Int,
        sessionToken: VCLToken
    ) -> VCLOffers {
        if let offersDictionary = payloadData.toDictionary() {
            // VCLXVnfProtocolVersion.XVnfProtocolVersion2
            return VCLOffers(
                payload: offersDictionary,
                all: offersFromJsonArray(offersDictionary[VCLOffers.CodingKeys.KeyOffers] as? [[String : Any]] ?? []),
                responseCode: responseCode,
                sessionToken: sessionToken,
                challenge: offersDictionary[VCLOffers.CodingKeys.KeyChallenge] as? String
            )
        } else if let offersListOfDictionaries = payloadData.toListOfDictionaries() {
            // VCLXVnfProtocolVersion.XVnfProtocolVersion1
            let offersJsonObject = "{\"\(VCLOffers.CodingKeys.KeyOffers)\":\(offersListOfDictionaries.toJsonArrayString() ?? "[]")}".toDictionary() ?? [:]
            return VCLOffers(
                payload: offersJsonObject,
                all: offersFromJsonArray(offersListOfDictionaries),
                responseCode: responseCode,
                sessionToken: sessionToken
            )
        } else {
            // No offers
            return VCLOffers(
                payload: [:],
                all: [],
                responseCode: responseCode,
                sessionToken: sessionToken
            )
        }
    }

    static func offersFromJsonArray(_ offersJsonArray: [[String: Any]]) -> [VCLOffer] {
        var allOffers = [VCLOffer]()
        for i in 0..<offersJsonArray.count {
            allOffers.append(VCLOffer(payload: offersJsonArray[i]))
        }
        return allOffers
    }

    
    public struct CodingKeys {
        public static let KeyOffers = "offers"
        public static let KeyChallenge = "challenge"
    }
}
