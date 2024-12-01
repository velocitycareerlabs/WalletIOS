//
//  VCLExchangeDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLExchangeDescriptor {
    public let presentationSubmission: VCLPresentationSubmission
    public let submissionResult: VCLSubmissionResult
    
    public var processUri: String { get { presentationSubmission.progressUri } }
    public var exchangeId: String? { get { submissionResult.exchange.id } }
    public var sessionToken: VCLToken { get { submissionResult.sessionToken } }
    
    public init(
        presentationSubmission: VCLPresentationSubmission,
        submissionResult: VCLSubmissionResult
    ) {
        self.presentationSubmission = presentationSubmission
        self.submissionResult = submissionResult
    }
    
    public struct CodingKeys {
        public static let KeyExchangeId = "exchange_id"
    }
}
