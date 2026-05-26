//
//  ErrorTaxonomyBackwardCompatibilityBaselineTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ErrorTaxonomyBackwardCompatibilityBaselineTest: XCTestCase {
    func testMalformedLinksAndMissingRequiredParamsReturnSdkError() {
        entryPoints.forEach { entryPoint in
            let missingDidDeepLink = VCLDeepLink(value: "velocity-network://\(entryPoint.schemePath)")
            
            [VCLDeepLink(value: "not a url"), missingDidDeepLink].forEach { deepLink in
                let error = getEntryPointError(entryPoint, deepLink: deepLink)
                
                XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
                XCTAssertTrue(error.message?.contains("did was not found") == true)
            }
        }
    }
    
    func testUnsupportedSchemeWithKnownQueryParamsReturnsNullEndpointSdkError() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "https://example.com/\(entryPoint.schemePath)?\(entryPoint.didParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, entryPoint.endpointNullMessage)
        }
    }
    
    func testUndecodableQueryParamsAreAcceptedUntilSdkEntryPoint() {
        [
            VCLDeepLink(value: "velocity-network://issue?request_uri=%"),
            VCLDeepLink(value: "velocity-network://inspect?request_uri=%")
        ].enumerated().forEach { index, deepLink in
            let error = getEntryPointError(entryPoints[index], deepLink: deepLink)
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertTrue(error.message?.contains("did was not found") == true)
        }
    }
    
    func testMissingRequestUriProducesEndpointNullSdkErrors() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?\(entryPoint.didParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, entryPoint.endpointNullMessage)
        }
    }
    
    func testMalformedAndDisallowedRequestUriValuesReachTransportAsRawEndpointText() {
        entryPoints.forEach { entryPoint in
            let malformedRequestUriDeepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=not-a-url" +
                    "&\(entryPoint.didParam)=did:example:entity"
            )
            let disallowedSchemeDeepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?" +
                    "request_uri=ftp%3A%2F%2Fexample.com%2Frequest" +
                    "&\(entryPoint.didParam)=did:example:entity"
            )
            let malformedRequestUri = getEntryPointError(entryPoint, deepLink: malformedRequestUriDeepLink)
            let disallowedSchemeRequestUri = getEntryPointError(entryPoint, deepLink: disallowedSchemeDeepLink)
            
            XCTAssertEqual(malformedRequestUri.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertTrue(
                malformedRequestUri.message?.contains("NSURLErrorDomain Code=-1002") == true,
                "message: \(malformedRequestUri.message ?? "nil")"
            )
            XCTAssertEqual(disallowedSchemeRequestUri.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertTrue(
                disallowedSchemeRequestUri.message?.contains("NSURLErrorDomain Code=-1002") == true,
                "message: \(disallowedSchemeRequestUri.message ?? "nil")"
            )
        }
    }
    
    func testTransportFailureReturnsSdkErrorWithNetworkStatusOnly() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestFailure: BaselineNetworkError(message: "offline"))
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, VCLStatusCode.NetworkError.rawValue)
            XCTAssertTrue(error.message?.contains("offline") == true)
        }
    }
    
    func testRequestEndpoint401And403PreserveHttpStatusAndPayloadErrorCode() {
        entryPoints.forEach { entryPoint in
            [401, 403].forEach { statusCode in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(
                        requestPayload: ErrorMocks.Payload,
                        requestStatusCode: statusCode,
                        requestContentType: Request.ContentType.ApplicationJson.rawValue
                    )
                )
                
                XCTAssertEqual(error.errorCode, ErrorMocks.ErrorCode)
                XCTAssertEqual(error.requestId, ErrorMocks.RequestId)
                XCTAssertEqual(error.message, ErrorMocks.Message)
                XCTAssertEqual(error.statusCode, ErrorMocks.StatusCode)
            }
        }
    }
    
    func testRequestEndpointRejectionsPreserveHttpStatusWhenPayloadHasNoStatusCode() {
        var payloadWithoutStatusCode = ErrorMocks.Payload.toDictionary()!
        payloadWithoutStatusCode.removeValue(forKey: VCLError.CodingKeys.KeyStatusCode)
        
        entryPoints.forEach { entryPoint in
            [400, 404, 409, 410, 422, 500, 502].forEach { statusCode in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(
                        requestPayload: payloadWithoutStatusCode.toJsonString()!,
                        requestStatusCode: statusCode,
                        requestContentType: Request.ContentType.ApplicationJson.rawValue
                    )
                )
                
                XCTAssertEqual(error.errorCode, ErrorMocks.ErrorCode)
                XCTAssertEqual(error.statusCode, statusCode)
            }
        }
    }
    
    func testPlainTextRequestEndpointRejectionsDefaultToSdkErrorWithHttpStatusAndPayloadMessage() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: "plain text failure",
                    requestStatusCode: 500,
                    requestContentType: "text/plain"
                )
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, 500)
            XCTAssertEqual(error.message, "plain text failure")
            XCTAssertNil(error.payload)
        }
    }
    
    func testJsonRequestEndpointRejectionsWithoutErrorCodeDefaultToSdkError() {
        var payloadWithoutErrorCode = ErrorMocks.Payload.toDictionary()!
        payloadWithoutErrorCode.removeValue(forKey: VCLError.CodingKeys.KeyErrorCode)
        
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: payloadWithoutErrorCode.toJsonString()!,
                    requestStatusCode: 422,
                    requestContentType: Request.ContentType.ApplicationJson.rawValue
                )
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.requestId, ErrorMocks.RequestId)
            XCTAssertEqual(error.message, ErrorMocks.Message)
            XCTAssertEqual(error.statusCode, ErrorMocks.StatusCode)
        }
    }
    
    func testEmptyRequestEndpointResponseReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
        }
    }
    
    func testMalformedRequestEndpointResponseReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "not json")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
        }
    }
    
    func testMissingExpectedRequestFieldsReturnSdkErrorAfterEmptyJwtIsDecoded() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "{}")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
        }
    }
    
    func testDidResolutionNetworkFailurePropagatesSdkErrorAndStatusFromNetwork() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    didDocumentPayload: #"{"message":"resolve failed","errorCode":"sdk_error"}"#,
                    didDocumentStatusCode: 404,
                    didDocumentContentType: Request.ContentType.ApplicationJson.rawValue
                )
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, 404)
            XCTAssertEqual(error.message, "resolve failed")
        }
    }
    
    func testInvalidDidDocumentShapeReturnsSdkErrorAtRequestValidation() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(didDocumentPayload: "not json")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, "Failed to parse not json")
        }
    }
    
    func testMissingDidDocumentVerificationMaterialReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(didDocumentPayload: "{}")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertTrue(
                error.error?.contains("public jwk not found for kid") == true,
                "error: \(error.error ?? "nil"), message: \(error.message ?? "nil")"
            )
        }
    }
    
    func testVerifiedProfileLookupFailurePropagatesNetworkErrorDetails() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    verifiedProfilePayload: #"{"message":"profile missing","errorCode":"sdk_error"}"#,
                    verifiedProfileStatusCode: 404,
                    verifiedProfileContentType: Request.ContentType.ApplicationJson.rawValue
                )
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, 404)
            XCTAssertEqual(error.message, "profile missing")
        }
    }
    
    func testEmptyVerifiedProfileFailsServiceTypeVerification() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(verifiedProfilePayload: "{}")
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, VCLStatusCode.VerificationError.rawValue)
            XCTAssertTrue(error.message?.contains("Wrong service type") == true)
        }
    }
    
    func testWrongIssuerOrVerifierServiceTypeReturnsSdkErrorWithVerificationStatus() {
        entryPoints.forEach { entryPoint in
            let wrongServiceProfile = entryPoint == .issuing
                ? VerifiedProfileMocks.VerifiedProfileInspectorJsonStr
                : VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(verifiedProfilePayload: wrongServiceProfile)
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.statusCode, VCLStatusCode.VerificationError.rawValue)
            XCTAssertTrue(error.message?.contains("Wrong service type") == true)
        }
    }
    
    func testDuplicateQueryParamsUseLastDidValueAtSdkEntryPoint() {
        entryPoints.forEach { entryPoint in
            let router = defaultRouter(entryPoint)
            let vcl = initializedVcl(router: router)
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=did:example:first&\(entryPoint.didParam)=\(entryPoint.lastDid)"
            )
            let error = entryPoint == .issuing
                ? awaitCredentialManifestError(vcl: vcl, descriptor: credentialManifestDescriptor(deepLink: deepLink))
                : awaitPresentationRequestError(vcl: vcl, descriptor: presentationDescriptor(deepLink: deepLink))
            
            XCTAssertEqual(error.errorCode, entryPoint.mismatchErrorCode)
            XCTAssertTrue(router.requestedEndpoints.contains { $0.contains(entryPoint.lastDid) })
        }
    }
    
    func testMalformedDidSyntaxIsAcceptedUntilRequestValidation() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=not-a-did"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            XCTAssertEqual(error.errorCode, entryPoint.mismatchErrorCode)
        }
    }
    
    func testRequestValidationFailuresUseLegacyMismatchErrorCodes() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=did:example:wrong"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            XCTAssertEqual(error.errorCode, entryPoint.mismatchErrorCode)
        }
    }
    
    func testJwtVerificationFailurePropagatesSdkErrorFromInjectedJwtService() {
        let expectedError = VCLError(
            errorCode: VCLErrorCode.SdkError.rawValue,
            message: "jwt signature verification failed"
        )
        
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                jwtVerificationResult: .failure(expectedError)
            )
            
            XCTAssertEqual(error.errorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, "jwt signature verification failed")
        }
    }
    
    fileprivate enum EntryPoint {
        case issuing
        case presentation
    }
    
    private let entryPoints: [EntryPoint] = [.issuing, .presentation]
    
    private func defaultRouter(_ entryPoint: EntryPoint) -> BaselineHttpRouter {
        switch entryPoint {
        case .issuing:
            return BaselineHttpRouter()
        case .presentation:
            return BaselineHttpRouter(
                verifiedProfilePayload: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr,
                requestPayload: PresentationRequestMocks.EncodedPresentationRequestResponse
            )
        }
    }
    
    private func getEntryPointError(
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
    
    private func getCredentialManifestError(
        deepLink: VCLDeepLink,
        router: BaselineHttpRouter,
        jwtVerificationResult: VCLResult<Bool>
    ) -> VCLError {
        let vcl = initializedVcl(router: router, jwtVerificationResult: jwtVerificationResult)
        return awaitCredentialManifestError(vcl: vcl, descriptor: credentialManifestDescriptor(deepLink: deepLink))
    }
    
    private func getPresentationRequestError(
        deepLink: VCLDeepLink,
        router: BaselineHttpRouter,
        jwtVerificationResult: VCLResult<Bool>
    ) -> VCLError {
        let vcl = initializedVcl(router: router, jwtVerificationResult: jwtVerificationResult)
        return awaitPresentationRequestError(vcl: vcl, descriptor: presentationDescriptor(deepLink: deepLink))
    }
    
    private func initializedVcl(
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
                )
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
    
    private func awaitCredentialManifestError(
        vcl: VCLImpl,
        descriptor: VCLCredentialManifestDescriptorByDeepLink
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
    
    private func awaitPresentationRequestError(
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
    
    private func credentialManifestDescriptor(deepLink: VCLDeepLink) -> VCLCredentialManifestDescriptorByDeepLink {
        VCLCredentialManifestDescriptorByDeepLink(
            deepLink: deepLink,
            didJwk: DidJwkMocks.DidJwk
        )
    }
    
    private func presentationDescriptor(deepLink: VCLDeepLink) -> VCLPresentationRequestDescriptor {
        VCLPresentationRequestDescriptor(
            deepLink: deepLink,
            didJwk: DidJwkMocks.DidJwk
        )
    }
    
    private static var cacheSequence = 1000
    private static func nextCacheSequence() -> Int {
        cacheSequence += 1
        return cacheSequence
    }
}

private extension ErrorTaxonomyBackwardCompatibilityBaselineTest.EntryPoint {
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
            return "credentialManifestDescriptor.endpoint = null"
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
    
    var didParam: String {
        switch self {
        case .issuing:
            return "issuerDid"
        case .presentation:
            return "inspectorDid"
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
}

private final class FixedJwtVerifyService: VCLJwtVerifyService {
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

private struct BaselineNetworkError: Error, CustomStringConvertible {
    let message: String
    var description: String { message }
}

private final class BaselineHttpRouter: NetworkService {
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
        didDocumentContentType: String? = Request.ContentType.ApplicationJson.rawValue
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
        didDocumentContentType: String? = nil
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
            didDocumentContentType: didDocumentContentType ?? self.didDocumentContentType
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
        
        return VCLError(
            message: errorPayload.isEmpty ? nil : errorPayload,
            statusCode: statusCode
        )
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
