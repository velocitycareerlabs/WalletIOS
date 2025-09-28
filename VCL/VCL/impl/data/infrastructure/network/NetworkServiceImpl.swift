//
//  NetworkService.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

final class NetworkServiceImpl: NetworkService {
    
    private let urlSession: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.waitsForConnectivity = false
        
        urlSession = URLSession(configuration: configuration)
    }
    
    func sendRequest(
        endpoint: String,
        body: String? = nil,
        contentType: Request.ContentType = .ApplicationJson,
        method: Request.HttpMethod,
        headers: Array<(String, String)>? = nil,
        cachePolicy: NSURLRequest.CachePolicy,
        completionBlock: @escaping (VCLResult<Response>) -> Void
    ) {
        sendRequest(
            request: Request.Builder()
                .setEndpoint(endpoint: endpoint)
                .setBody(body: body)
                .setContentType(contentType: contentType)
                .setMethod(method: method)
                .addHeaders(headers: headers)
                .setCachePolicy(cachePolicy: cachePolicy)
                .build(),
            completionBlock: completionBlock
        )
    }
    
    private func sendRequest(request: Request, completionBlock: @escaping (VCLResult<Response>) -> Void) {
        logRequest(request)
        guard let urlRequest = createUrlRequest(request: request) else {
            completionBlock(.failure(VCLError(message: "Request error: \(request.stringify())")))
            return
        }
        
//        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] (data, response, error) in
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            
            if let taskError = error {
                completionBlock(.failure(VCLError(error: taskError, statusCode: VCLStatusCode.NetworkError.rawValue)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completionBlock(.failure(VCLError(message: "Empty response")))
                return
            }
            guard let jsonData = data else {
                completionBlock(.failure(VCLError(message: "Empty data received")))
                return
            }
            if (200...299).contains(httpResponse.statusCode) {
                let response = Response(payload: jsonData, code: httpResponse.statusCode)
                self?.logResponse(response)
                completionBlock(.success(response))
            } else {
                completionBlock(.failure(
                    VCLError(payload: String(data: jsonData, encoding: .utf8) ?? "")
                ))
            }
        }
        task.resume()
    }
    
    private func createUrlRequest(request: Request) -> URLRequest? {
        guard let url = URL(string: request.endpoint) else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = request.cachePolicy
        urlRequest.httpMethod = request.method.rawValue
        if(request.method == Request.HttpMethod.POST && request.body != nil) {
            urlRequest.httpBody = request.body?.data(using: request.encoding)
        }
        urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Content-Type")
        guard let headers = request.headers else {
            return urlRequest
        }
        for header in headers {
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }
        return urlRequest
    }
    
    private func logRequest(_ request: Request) {
        let logMethod = "Request Method: \(request.method)"
        let endpointLog = " Request Endpoint: \(request.endpoint)"
        var bodyLog = "\n"
        if let body = request.body {
            bodyLog = "\nRequest Body: \n\(body)"
        }
        VCLLog.d("\(logMethod)\(endpointLog)\(bodyLog)")
    }
    
    private func logResponse(_ response: Response) {
        VCLLog.d("Response:\nstatus code: \(response.code)")
        VCLLog.d(response.payload)
    }
}
