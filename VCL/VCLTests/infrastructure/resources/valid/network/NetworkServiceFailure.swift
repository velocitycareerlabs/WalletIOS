//
//  NetworkServiceFailure.swift
//  VCL
//
//  Created by Michael Avoyan on 27/04/2025.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

final class NetworkServiceFailure: NetworkService {
    private let errorMessage: String
    
    init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    func sendRequest(
            endpoint: String,
            body: String?,
            contentType: Request.ContentType,
            method: Request.HttpMethod,
            headers: Array<(String, String)>?,
            cachePolicy: NSURLRequest.CachePolicy,
            completionBlock: @escaping (VCLResult<Response>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: errorMessage)))
    }
}

