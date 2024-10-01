//
//  NetworkServiceSuccess.swift
//  
//
//  Created by Michael Avoyan on 02/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

final class NetworkServiceSuccess: NetworkService {
    private let validResponse: String
    
    init(validResponse: String) {
        self.validResponse = validResponse
    }
    
    func sendRequest(
            endpoint: String,
            body: String?,
            contentType: Request.ContentType,
            method: Request.HttpMethod,
            headers: Array<(String, String)>?,
            cachePolicy: NSURLRequest.CachePolicy,
            completionBlock: @escaping @Sendable (VCLResult<Response>) -> Void
    ) {
        completionBlock(.success(Response(payload: self.validResponse.toData(), code: 0)))
    }
}
