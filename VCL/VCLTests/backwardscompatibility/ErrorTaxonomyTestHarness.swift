//
//  ErrorTaxonomyTestHarness.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class ErrorTaxonomyTestCase: XCTestCase {
    enum EntryPoint {
        case issuing
        case presentation
    }

    let entryPoints: [EntryPoint] = [.issuing, .presentation]

    var errorCodeCompatibilityMode: VCLErrorCodeCompatibilityMode {
        .Taxonomy
    }

    func defaultRouter(_ entryPoint: EntryPoint) -> BaselineHttpRouter {
        switch entryPoint {
        case .issuing:
            return BaselineHttpRouter(
                includePlainTextFailurePayload: errorCodeCompatibilityMode == .Taxonomy
            )
        case .presentation:
            return BaselineHttpRouter(
                verifiedProfilePayload: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr,
                requestPayload: PresentationRequestMocks.EncodedPresentationRequestResponse,
                includePlainTextFailurePayload: errorCodeCompatibilityMode == .Taxonomy
            )
        }
    }

    func getEntryPointError(
        _ entryPoint: EntryPoint,
        deepLink: VCLDeepLink? = nil,
        router: BaselineHttpRouter? = nil,
        jwtVerificationResult: VCLResult<Bool> = .success(true)
    ) -> VCLError {
        switch entryPoint {
        case .issuing:
            return getCredentialManifestError(
                deepLink: deepLink ?? entryPoint.defaultDeepLink,
                router: router ?? defaultRouter(entryPoint),
                jwtVerificationResult: jwtVerificationResult
            )
        case .presentation:
            return getPresentationRequestError(
                deepLink: deepLink ?? entryPoint.defaultDeepLink,
                router: router ?? defaultRouter(entryPoint),
                jwtVerificationResult: jwtVerificationResult
            )
        }
    }

    func getCredentialManifestError(
        deepLink: VCLDeepLink,
        router: BaselineHttpRouter,
        jwtVerificationResult: VCLResult<Bool>
    ) -> VCLError {
        let vcl = initializedVcl(router: router, jwtVerificationResult: jwtVerificationResult)
        return awaitCredentialManifestError(vcl: vcl, descriptor: credentialManifestDescriptor(deepLink: deepLink))
    }

    func getPresentationRequestError(
        deepLink: VCLDeepLink,
        router: BaselineHttpRouter,
        jwtVerificationResult: VCLResult<Bool>
    ) -> VCLError {
        let vcl = initializedVcl(router: router, jwtVerificationResult: jwtVerificationResult)
        return awaitPresentationRequestError(vcl: vcl, descriptor: presentationDescriptor(deepLink: deepLink))
    }

    func initializedVcl(
        router: BaselineHttpRouter,
        jwtVerificationResult: VCLResult<Bool> = .success(true)
    ) -> VCLImpl {
        let vcl = VCLImpl(networkServiceFactory: { router })
        let expectation = expectation(description: "VCL initialized")
        var initError: VCLError?
        vcl.initialize(
            initializationDescriptor: VCLInitializationDescriptor(
                cacheSequence: Self.nextCacheSequence(),
                cryptoServicesDescriptor: VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtSignService: VCLJwtSignServiceMock(),
                        jwtVerifyService: FixedJwtVerifyService(result: jwtVerificationResult)
                    )
                ),
                errorCodeCompatibilityMode: errorCodeCompatibilityMode
            ),
            successHandler: { expectation.fulfill() },
            errorHandler: {
                initError = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(initError, "VCL initialization failed: \(String(describing: initError?.toDictionary()))")
        return vcl
    }

    func awaitCredentialManifestError(
        vcl: VCLImpl,
        descriptor: VCLCredentialManifestDescriptor
    ) -> VCLError {
        let expectation = expectation(description: "credential manifest failure")
        var result: VCLError?
        vcl.getCredentialManifest(
            credentialManifestDescriptor: descriptor,
            successHandler: { manifest in
                XCTFail("Credential manifest failure expected: \(manifest)")
                expectation.fulfill()
            },
            errorHandler: {
                result = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        return result ?? VCLError(message: "getCredentialManifest did not invoke errorHandler")
    }

    func awaitCredentialManifest(
        vcl: VCLImpl,
        descriptor: VCLCredentialManifestDescriptor
    ) -> VCLCredentialManifest {
        let expectation = expectation(description: "credential manifest success")
        var result: VCLCredentialManifest?
        var error: VCLError?
        vcl.getCredentialManifest(
            credentialManifestDescriptor: descriptor,
            successHandler: {
                result = $0
                expectation.fulfill()
            },
            errorHandler: {
                error = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        XCTAssertNil(error, "getCredentialManifest failed: \(String(describing: error?.toDictionary()))")
        return result ?? VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifest1),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary() ?? [:]),
            didJwk: DidJwkMocks.DidJwk
        )
    }

    func awaitPresentationRequestError(
        vcl: VCLImpl,
        descriptor: VCLPresentationRequestDescriptor
    ) -> VCLError {
        let expectation = expectation(description: "presentation request failure")
        var result: VCLError?
        vcl.getPresentationRequest(
            presentationRequestDescriptor: descriptor,
            successHandler: { presentationRequest in
                XCTFail("Presentation request failure expected: \(presentationRequest)")
                expectation.fulfill()
            },
            errorHandler: {
                result = $0
                expectation.fulfill()
            }
        )
        wait(for: [expectation], timeout: 5)
        return result ?? VCLError(message: "getPresentationRequest did not invoke errorHandler")
    }

    func credentialManifestDescriptor(deepLink: VCLDeepLink) -> VCLCredentialManifestDescriptorByDeepLink {
        VCLCredentialManifestDescriptorByDeepLink(
            deepLink: deepLink,
            didJwk: DidJwkMocks.DidJwk
        )
    }

    func credentialManifestDescriptorByService(
        endpoint: String = CredentialManifestDescriptorMocks.IssuingServiceEndPoint,
        did: String = DeepLinkMocks.IssuerDid
    ) -> VCLCredentialManifestDescriptorByService {
        VCLCredentialManifestDescriptorByService(
            service: VCLService(payload: [
                VCLService.CodingKeys.KeyId: "\(DeepLinkMocks.IssuerDid)#credential-agent-issuer-1",
                VCLService.CodingKeys.KeyType: VCLServiceType.CareerIssuer.rawValue,
                VCLService.CodingKeys.KeyServiceEndpoint: endpoint
            ]),
            didJwk: DidJwkMocks.DidJwk,
            did: did
        )
    }

    func presentationDescriptor(deepLink: VCLDeepLink) -> VCLPresentationRequestDescriptor {
        VCLPresentationRequestDescriptor(
            deepLink: deepLink,
            didJwk: DidJwkMocks.DidJwk
        )
    }

    func encodedJwtWithoutKid(_ encodedJwt: String) -> String {
        var header = jwtHeader(encodedJwt)
        header.removeValue(forKey: VCLJwt.CodingKeys.KeyKid)
        return encodedJwtWithHeader(encodedJwt, header: header)
    }

    func encodedJwtWithKid(_ encodedJwt: String, kid: String) -> String {
        var header = jwtHeader(encodedJwt)
        header[VCLJwt.CodingKeys.KeyKid] = kid
        return encodedJwtWithHeader(encodedJwt, header: header)
    }

    private func jwtHeader(_ encodedJwt: String) -> [String: Any] {
        let parts = encodedJwt.components(separatedBy: ".")
        return parts.first?.decodeBase64URL()?.toDictionary() ?? [:]
    }

    private func encodedJwtWithHeader(_ encodedJwt: String, header: [String: Any]) -> String {
        var parts = encodedJwt.components(separatedBy: ".")
        let data = (header.toJsonString() ?? "{}").data(using: .utf8) ?? Data()
        parts[0] = data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        return parts.joined(separator: ".")
    }

    private static var cacheSequence = 1000
    private static func nextCacheSequence() -> Int {
        cacheSequence += 1
        return cacheSequence
    }
}

extension ErrorTaxonomyTestCase.EntryPoint {
    var defaultDeepLink: VCLDeepLink {
        switch self {
        case .issuing:
            return DeepLinkMocks.CredentialManifestDeepLinkDevNet
        case .presentation:
            return DeepLinkMocks.PresentationRequestDeepLinkDevNet
        }
    }

    var endpointNullMessage: String {
        switch self {
        case .issuing:
            return "credentialManifestDescriptor.endpoint = null"
        case .presentation:
            return "presentationRequestDescriptor.endpoint = null"
        }
    }

    var mismatchErrorCode: String {
        switch self {
        case .issuing:
            return VCLErrorCode.MismatchedRequestIssuerDid.rawValue
        case .presentation:
            return VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue
        }
    }

    var requestInvalidCode: VCLErrorCode {
        switch self {
        case .issuing:
            return .IssuerRequestInvalid
        case .presentation:
            return .VerifierRequestInvalid
        }
    }

    var didUnresolvableCode: VCLErrorCode {
        switch self {
        case .issuing:
            return .IssuerDidUnresolvable
        case .presentation:
            return .VerifierDidUnresolvable
        }
    }

    var notRegisteredCode: VCLErrorCode {
        switch self {
        case .issuing:
            return .IssuerNotRegistered
        case .presentation:
            return .VerifierNotRegistered
        }
    }

    var requestUnauthorizedCode: VCLErrorCode {
        switch self {
        case .issuing:
            return .IssuerRequestUnauthorized
        case .presentation:
            return .VerifierRequestUnauthorized
        }
    }

    var requestKind: String {
        switch self {
        case .issuing:
            return ErrorTaxonomy.requestKindIssuing
        case .presentation:
            return ErrorTaxonomy.requestKindPresentation
        }
    }

    var requestDid: String {
        switch self {
        case .issuing:
            return DeepLinkMocks.IssuerDid
        case .presentation:
            return DeepLinkMocks.InspectorDid
        }
    }

    var didParam: String {
        switch self {
        case .issuing:
            return "issuerDid"
        case .presentation:
            return "inspectorDid"
        }
    }

    var otherDidParam: String {
        switch self {
        case .issuing:
            return "inspectorDid"
        case .presentation:
            return "issuerDid"
        }
    }

    var schemePath: String {
        switch self {
        case .issuing:
            return "issue"
        case .presentation:
            return "inspect"
        }
    }

    var encodedRequestUri: String {
        switch self {
        case .issuing:
            return DeepLinkMocks.CredentialManifestRequestUriStr
        case .presentation:
            return DeepLinkMocks.PresentationRequestRequestUriStr
        }
    }

    var lastDid: String {
        "did:example:last"
    }

    var defaultRequestJwt: String {
        switch self {
        case .issuing:
            return CredentialManifestMocks.JwtCredentialManifest1
        case .presentation:
            return PresentationRequestMocks.EncodedPresentationRequest
        }
    }

    func requestPayload(for encodedJwt: String) -> String {
        switch self {
        case .issuing:
            return [VCLCredentialManifest.CodingKeys.KeyIssuingRequest: encodedJwt].toJsonString() ?? "{}"
        case .presentation:
            return [VCLPresentationRequest.CodingKeys.KeyPresentationRequest: encodedJwt].toJsonString() ?? "{}"
        }
    }
}

final class FixedJwtVerifyService: VCLJwtVerifyService {
    private let result: VCLResult<Bool>

    init(result: VCLResult<Bool>) {
        self.result = result
    }

    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        completionBlock(result)
    }
}

struct BaselineNetworkError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

final class BaselineHttpRouter: NetworkService {
    private let verifiedProfilePayload: String
    private let verifiedProfileStatusCode: Int
    private let verifiedProfileContentType: String?
    private let requestPayload: String
    private let requestStatusCode: Int
    private let requestContentType: String?
    private let requestFailure: Error?
    private let didDocumentPayload: String
    private let didDocumentStatusCode: Int
    private let didDocumentContentType: String?
    private let includePlainTextFailurePayload: Bool
    private let lock = NSLock()
    private var endpoints: [String] = []

    var requestedEndpoints: [String] {
        lock.lock()
        defer { lock.unlock() }
        return endpoints
    }

    init(
        verifiedProfilePayload: String = VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1,
        verifiedProfileStatusCode: Int = 200,
        verifiedProfileContentType: String? = Request.ContentType.ApplicationJson.rawValue,
        requestPayload: String = CredentialManifestMocks.CredentialManifest1,
        requestStatusCode: Int = 200,
        requestContentType: String? = Request.ContentType.ApplicationJson.rawValue,
        requestFailure: Error? = nil,
        didDocumentPayload: String = DidDocumentMocks.DidDocumentMockStr,
        didDocumentStatusCode: Int = 200,
        didDocumentContentType: String? = Request.ContentType.ApplicationJson.rawValue,
        includePlainTextFailurePayload: Bool = false
    ) {
        self.verifiedProfilePayload = verifiedProfilePayload
        self.verifiedProfileStatusCode = verifiedProfileStatusCode
        self.verifiedProfileContentType = verifiedProfileContentType
        self.requestPayload = requestPayload
        self.requestStatusCode = requestStatusCode
        self.requestContentType = requestContentType
        self.requestFailure = requestFailure
        self.didDocumentPayload = didDocumentPayload
        self.didDocumentStatusCode = didDocumentStatusCode
        self.didDocumentContentType = didDocumentContentType
        self.includePlainTextFailurePayload = includePlainTextFailurePayload
    }

    func copy(
        verifiedProfilePayload: String? = nil,
        verifiedProfileStatusCode: Int? = nil,
        verifiedProfileContentType: String? = nil,
        requestPayload: String? = nil,
        requestStatusCode: Int? = nil,
        requestContentType: String? = nil,
        requestFailure: Error? = nil,
        didDocumentPayload: String? = nil,
        didDocumentStatusCode: Int? = nil,
        didDocumentContentType: String? = nil,
        includePlainTextFailurePayload: Bool? = nil
    ) -> BaselineHttpRouter {
        BaselineHttpRouter(
            verifiedProfilePayload: verifiedProfilePayload ?? self.verifiedProfilePayload,
            verifiedProfileStatusCode: verifiedProfileStatusCode ?? self.verifiedProfileStatusCode,
            verifiedProfileContentType: verifiedProfileContentType ?? self.verifiedProfileContentType,
            requestPayload: requestPayload ?? self.requestPayload,
            requestStatusCode: requestStatusCode ?? self.requestStatusCode,
            requestContentType: requestContentType ?? self.requestContentType,
            requestFailure: requestFailure ?? self.requestFailure,
            didDocumentPayload: didDocumentPayload ?? self.didDocumentPayload,
            didDocumentStatusCode: didDocumentStatusCode ?? self.didDocumentStatusCode,
            didDocumentContentType: didDocumentContentType ?? self.didDocumentContentType,
            includePlainTextFailurePayload: includePlainTextFailurePayload ?? self.includePlainTextFailurePayload
        )
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
        append(endpoint)
        if isSdkRequestEndpoint(endpoint) {
            if let requestFailure = requestFailure {
                completionBlock(.failure(VCLError(
                    error: requestFailure,
                    statusCode: VCLStatusCode.NetworkError.rawValue
                )))
                return
            }
            if endpoint.hasPrefix("not-a-url") || endpoint.hasPrefix("ftp://") {
                completionBlock(.failure(VCLError(
                    error: URLError(.unsupportedURL),
                    statusCode: VCLStatusCode.NetworkError.rawValue
                )))
                return
            }
        }

        let route = route(for: endpoint)
        if (200...299).contains(route.statusCode) {
            completionBlock(.success(Response(payload: route.payload.toData(), code: route.statusCode)))
        } else {
            completionBlock(.failure(createError(
                from: route.payload,
                contentType: route.contentType,
                statusCode: route.statusCode
            )))
        }
    }

    private func append(_ endpoint: String) {
        lock.lock()
        endpoints.append(endpoint)
        lock.unlock()
    }

    private func route(for endpoint: String) -> Route {
        if endpoint.contains("/reference/countries") {
            return Route(200, Request.ContentType.ApplicationJson.rawValue, CountriesMocks.CountriesJson)
        }
        if endpoint.contains("/api/v0.6/credential-types") {
            return Route(200, Request.ContentType.ApplicationJson.rawValue, CredentialTypesMocks.CredentialTypesJson)
        }
        if endpoint.contains("/schemas/") {
            return Route(200, Request.ContentType.ApplicationJson.rawValue, CredentialTypeSchemaMocks.CredentialTypeSchemaJson)
        }
        if endpoint.contains("/verified-profile") {
            return Route(verifiedProfileStatusCode, verifiedProfileContentType, verifiedProfilePayload)
        }
        if endpoint.contains("/resolve-did/") {
            return Route(didDocumentStatusCode, didDocumentContentType, didDocumentPayload)
        }
        if isSdkRequestEndpoint(endpoint) {
            return Route(requestStatusCode, requestContentType, requestPayload)
        }
        return Route(500, "text/plain", "Unhandled HTTP endpoint in baseline test: \(endpoint)")
    }

    private func isSdkRequestEndpoint(_ endpoint: String) -> Bool {
        endpoint.contains("get-credential-manifest") ||
            endpoint.contains("get-presentation-request") ||
            endpoint.hasPrefix("not-a-url") ||
            endpoint.hasPrefix("ftp://")
    }

    private func createError(from errorPayload: String, contentType: String?, statusCode: Int) -> VCLError {
        if isJsonContentType(contentType) {
            return VCLError(
                error: VCLError(payload: errorPayload),
                statusCode: statusCode
            )
        }

        if includePlainTextFailurePayload {
            return VCLError(
                payload: errorPayload.isEmpty ? nil : errorPayload,
                message: errorPayload.isEmpty ? nil : errorPayload,
                statusCode: statusCode
            )
        }
        return VCLError(message: errorPayload.isEmpty ? nil : errorPayload, statusCode: statusCode)
    }

    private func isJsonContentType(_ contentType: String?) -> Bool {
        guard let contentType = contentType?.lowercased() else {
            return false
        }
        return contentType.contains("application/json") || contentType.contains("+json")
    }
}

private struct Route {
    let statusCode: Int
    let contentType: String?
    let payload: String

    init(_ statusCode: Int, _ contentType: String?, _ payload: String) {
        self.statusCode = statusCode
        self.contentType = contentType
        self.payload = payload
    }
}
