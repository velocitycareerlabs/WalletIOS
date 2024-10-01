//
//  NetworkService.swift
//  
//
//  Created by Michael Avoyan on 28/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol NetworkService: Sendable {
    func sendRequest(
        endpoint: String,
        body: String?,
        contentType: Request.ContentType,
        method: Request.HttpMethod,
        headers: Array<(String, String)>?,
        cachePolicy: NSURLRequest.CachePolicy,
        completionBlock: @escaping @Sendable (VCLResult<Response>) -> Void
    )
}

extension NetworkService {
    func sendRequest(
        endpoint: String,
        body: String? = nil,
        contentType: Request.ContentType = .ApplicationJson,
        method: Request.HttpMethod,
        headers: Array<(String, String)>? = nil,
        cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData,
        completionBlock: @escaping @Sendable (VCLResult<Response>) -> Void
    ) {
        sendRequest(
            endpoint: endpoint,
            body: body,
            contentType: contentType,
            method: method,
            headers: headers,
            cachePolicy: cachePolicy,
            completionBlock: completionBlock
        )
    }
}
