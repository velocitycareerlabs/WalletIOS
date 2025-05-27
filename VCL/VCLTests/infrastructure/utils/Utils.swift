//
//  Utils.swift
//  VCL
//
//  Created by Michael Avoyan on 27/05/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

internal func expectedSubmissionResult(_ jsonDict: [String: Any], _ jti: String, submissionId: String) -> VCLSubmissionResult {
    let exchangeJsonDict = jsonDict[VCLSubmissionResult.CodingKeys.KeyExchange]
    return VCLSubmissionResult(
        sessionToken: VCLToken(value: (jsonDict[VCLSubmissionResult.CodingKeys.KeyToken] as! String)),
        exchange: expectedExchange(exchangeJsonDict as! [String : Any]),
        jti: jti,
        submissionId: submissionId
    )
}

internal func expectedExchange(_ exchangeJsonDict: [String: Any]) -> VCLExchange {
    return VCLExchange(
        id: (exchangeJsonDict[VCLExchange.CodingKeys.KeyId] as! String),
        type: (exchangeJsonDict[VCLExchange.CodingKeys.KeyType] as! String),
        disclosureComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyDisclosureComplete] as! Bool),
        exchangeComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyExchangeComplete] as! Bool)
    )
}

