//
//  VCLExchangeDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//

import Foundation

public struct VCLExchangeDescriptor {
    public let presentationSubmission: VCLPresentationSubmission
    public let submissionResult: VCLSubmissionResult
    
    public var processUri: String { get { presentationSubmission.progressUri } }
    public var did: String { get { presentationSubmission.iss } }
    public var exchangeId: String? { get { submissionResult.exchange.id } }
    public var token: VCLToken { get { submissionResult.token } }
    
    public init(presentationSubmission: VCLPresentationSubmission,
                submissionResult: VCLSubmissionResult) {
        self.presentationSubmission = presentationSubmission
        self.submissionResult = submissionResult
    }
    
    public struct CodingKeys {
        static let KeyExchangeId = "exchange_id"
        static let HeaderKeyAuthorization = "Authorization"
        static let HeaderValuePrefixBearer = "Bearer"
    }
}
