//
//  NetworkService.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//

import Foundation

class NetworkServiceImpl: NetworkService {

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
    
    private func sendRequest(request: Request,completionBlock: @escaping (VCLResult<Response>) -> Void) {
        logRequest(request)
        guard let urlRequest = createUrlRequest(request: request) else {
            completionBlock(.failure(VCLError(description: "Request error: \(request.stringify())")))
          return
        }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let taskError = error {
                completionBlock(.failure(VCLError(error: taskError, code: VCLErrorCodes.NetworkError.rawValue)))
            }
            else {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completionBlock(.failure(VCLError(description: "Empty response")))
                    return
                }
                guard let jsonData = data else {
                    completionBlock(.failure(VCLError(description:"Empty data received")))
                    return
                }
                if (200...299).contains(httpResponse.statusCode) {
                    let response = Response(payload: jsonData, code: httpResponse.statusCode)
                    completionBlock(.success(response))
                }
                else {
                    completionBlock(.failure(VCLError(
                                                    description:
                        "Connection failed: \((String(data: data ?? Data(bytes: [] as [UInt8], count: 0), encoding: .utf8)) ?? "")",
                                                    code: httpResponse.statusCode)))
                }
            }
        }
        task.resume()
    }
    
//    private func createSession(request: Request) -> URLSession {
//        let config = URLSessionConfiguration.default
//        config.timeoutIntervalForRequest = TimeInterval(request.timeoutIntervalForRequest)
//        config.requestCachePolicy = request.cachePolicy
//        return URLSession(configuration: config) // Load configuration into Session
//    }
    
    private func createUrlRequest(request: Request) -> URLRequest? {
        guard let url = URL(string: request.endpoint) else {
          return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if(request.method == Request.HttpMethod.POST && request.body != nil) {
            urlRequest.httpBody = request.body?.data(using: request.encoding)
        }
        urlRequest.setValue(request.contentType.rawValue, forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        guard let headers = request.headers else {
          return urlRequest
        }
        for header in headers {
            urlRequest.addValue(header.1, forHTTPHeaderField: header.0)
        }
        return urlRequest
    }
    
    private func logRequest(_ request: Request) {
        let logMethod = "Method: \(request.method)"
        let endpointLog = "\nEndpoint: \(request.endpoint)"
        var bodyLog = ""
        if let body = request.body {
            bodyLog = "\nBody: \(body)"
        }
        VCLLog.d("\(logMethod)\(endpointLog)\(bodyLog)")
    }
}
