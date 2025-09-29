//
//  Request.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class Request {
    private(set) var endpoint: String
    private(set) var body: String?
    private(set) var method: HttpMethod
    private(set) var headers: Array<(String, String)>?
    private(set) var cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData
//    private(set) var timeoutIntervalForRequest: Int
    private(set) var encoding: String.Encoding
    private(set) var contentType: ContentType
        
    static let DefaultEncoding = String.Encoding.utf8

    enum ContentType: String {
        case ApplicationJson = "application/json"
    }
    
    enum HttpMethod: String {
        case POST
        case GET
    }

    init(builder: Builder) {
        endpoint = builder.endpoint
        method = builder.method
        headers = builder.headers
        body = builder.body
//        timeoutIntervalForRequest = builder.timeoutIntervalForRequest
        encoding = builder.encoding
        contentType = builder.contentType
    }

    class Builder {
        var endpoint: String = ""
        var body: String? = nil
        var method: HttpMethod = HttpMethod.POST
        var headers: Array<(String, String)> = Array()
        var cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData
//        var timeoutIntervalForRequest: Int = DefaultTimeoutIntervalForRequest
        var encoding: String.Encoding = DefaultEncoding
        var contentType: ContentType = .ApplicationJson

        func setBody(body: String?) -> Builder {
            self.body = body
            return self
        }

        func setEncoding(encoding: String.Encoding) -> Builder {
            self.encoding = encoding
            return self
        }

//        func setTimeoutIntervalForRequest(timeoutIntervalForRequest: Int) -> Builder {
//            self.timeoutIntervalForRequest = timeoutIntervalForRequest
//            return self
//        }

        func setEndpoint(endpoint: String) -> Builder {
            self.endpoint = endpoint
            return self
        }

        func addHeader(header: (String, String)) -> Builder {
            headers.append(header)
            return self
        }

        func addHeaders(headers: Array<(String, String)>?) -> Builder {
            guard let h = headers else { return self }
            self.headers.append(contentsOf: h)
            return self
        }

        func setContentType(contentType: ContentType) -> Builder {
            self.contentType = contentType
            return self
        }

        func setMethod(method: HttpMethod!) -> Builder {
            self.method = Request.HttpMethod(rawValue: method.rawValue)!
            return self
        }

        func setCachePolicy(cachePolicy: NSURLRequest.CachePolicy) -> Builder {
            self.cachePolicy = cachePolicy
            return self
        }

        func build() -> Request {
            return Request(builder: self)
        }
    }
    
    func stringify() -> String {
        return "endpoint: \(endpoint), method: \(method), body: \(body ?? ""), contentType: \(contentType)"
    }
}
