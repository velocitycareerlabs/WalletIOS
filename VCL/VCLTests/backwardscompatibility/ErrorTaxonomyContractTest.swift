//
//  ErrorTaxonomyContractTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ErrorTaxonomyContractTest: XCTestCase {
    func testMalformedLinksAndMissingRequiredParamsReturnInvalidLink() {
        entryPoints.forEach { entryPoint in
            let missingDidDeepLink = VCLDeepLink(value: "velocity-network://\(entryPoint.schemePath)")
            
            [VCLDeepLink(value: "not a url"), missingDidDeepLink].forEach { deepLink in
                let error = getEntryPointError(entryPoint, deepLink: deepLink)
                
                assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
            }
        }
    }
    
    func testUnsupportedSchemeWithKnownQueryParamsReturnsInvalidLink() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "https://example.com/\(entryPoint.schemePath)?\(entryPoint.didParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
        }
    }
    
    func testUnsupportedFlowPathReturnsInvalidLink() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://unknown-flow?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
        }
    }
    
    func testWrongFlowDidParamUsesSwiftCompatibilityDidResolution() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.otherDidParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, entryPoint.mismatchErrorCode)
        }
    }
    
    func testUndecodableQueryParamsAreAcceptedUntilSdkEntryPoint() {
        [
            VCLDeepLink(value: "velocity-network://issue?request_uri=%"),
            VCLDeepLink(value: "velocity-network://inspect?request_uri=%")
        ].enumerated().forEach { index, deepLink in
            let error = getEntryPointError(entryPoints[index], deepLink: deepLink)
            
            assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoints[index].requestKind)
        }
    }
    
    func testMissingRequestUriProducesInvalidLink() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?\(entryPoint.didParam)=did:example:entity"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
        }
    }
    
    func testMalformedAndDisallowedRequestUriValuesReturnInvalidLink() {
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
            
            assertTaxonomy(malformedRequestUri, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
            assertTaxonomy(disallowedSchemeRequestUri, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
        }
    }
    
    func testInvalidDirectRequestEndpointReturnsInvalidLink() {
        let endpoint = "ftp://example.com/request"
        let error = getCredentialManifestDescriptorError(
            descriptor: credentialManifestDescriptorByService(endpoint: endpoint)
        )
        
        assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: ErrorTaxonomy.requestKindIssuing)
        XCTAssertEqual(error.sourceErrorCode, VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint)
        XCTAssertEqual(error.requestUri, endpoint)
    }
    
    func testMissingDirectRequestEndpointReturnsInvalidLink() {
        let error = getCredentialManifestDescriptorError(
            descriptor: credentialManifestDescriptorByService(endpoint: "")
        )
        
        assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: ErrorTaxonomy.requestKindIssuing)
        XCTAssertEqual(error.sourceErrorCode, VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint)
        XCTAssertEqual(error.requestUri, "")
    }
    
    func testMissingDirectRequestDidReturnsInvalidLink() {
        let error = getCredentialManifestDescriptorError(
            descriptor: credentialManifestDescriptorByService(did: "")
        )
        
        assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: ErrorTaxonomy.requestKindIssuing)
        XCTAssertTrue(error.message?.contains("did was not found") == true)
    }
    
    func testTransportFailureReturnsConnectivityFailureWithNetworkStatusOnly() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestFailure: BaselineNetworkError(message: "offline"))
            )
            
            assertTaxonomy(error, code: .ConnectivityFailure, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
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
                
                assertTaxonomy(error, code: .ClientRequestUnauthorized, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
                XCTAssertEqual(error.sourceErrorCode, ErrorMocks.ErrorCode)
                XCTAssertEqual(error.requestId, ErrorMocks.RequestId)
                XCTAssertEqual(error.message, ErrorMocks.Message)
                XCTAssertEqual(error.statusCode, statusCode)
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
                
                assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
                XCTAssertEqual(error.sourceErrorCode, ErrorMocks.ErrorCode)
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
            
            assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
            XCTAssertEqual(error.statusCode, 500)
            XCTAssertEqual(error.message, "plain text failure")
            XCTAssertEqual(error.payload, "plain text failure")
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
            
            assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
            XCTAssertEqual(error.requestId, ErrorMocks.RequestId)
            XCTAssertEqual(error.message, ErrorMocks.Message)
            XCTAssertEqual(error.statusCode, 422)
        }
    }
    
    func testEmptyRequestEndpointResponseReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "")
            )
            
            assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
        }
    }
    
    func testMalformedRequestEndpointResponseReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "not json")
            )
            
            assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
        }
    }
    
    func testMissingExpectedRequestFieldsReturnSdkErrorAfterEmptyJwtIsDecoded() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "{}")
            )
            
            assertTaxonomy(error, code: .ClientRequestRejected, phase: ErrorTaxonomy.phaseClientRequestFetch, kind: entryPoint.requestKind)
        }
    }
    
    func testCredentialManifestByServiceSucceedsWithoutDeepLinkVerification() {
        let vcl = initializedVcl(router: BaselineHttpRouter())
        let credentialManifest = awaitCredentialManifest(
            vcl: vcl,
            descriptor: credentialManifestDescriptorByService()
        )
        
        XCTAssertNil(credentialManifest.deepLink)
        XCTAssertEqual(credentialManifest.did, DeepLinkMocks.IssuerDid)
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
            
            assertTaxonomy(error, code: entryPoint.didUnresolvableCode, phase: ErrorTaxonomy.phaseDidResolution, kind: entryPoint.requestKind)
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
            
            assertTaxonomy(error, code: entryPoint.didUnresolvableCode, phase: ErrorTaxonomy.phaseDidResolution, kind: entryPoint.requestKind)
            XCTAssertTrue(error.message?.contains("public jwk not found for kid") == true)
        }
    }
    
    func testMissingDidDocumentVerificationMaterialReturnsSdkError() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(didDocumentPayload: "{}")
            )
            
            assertTaxonomy(error, code: entryPoint.didUnresolvableCode, phase: ErrorTaxonomy.phaseDidResolution, kind: entryPoint.requestKind)
            XCTAssertTrue(
                error.message?.contains("public jwk not found for kid") == true,
                "error: \(error.error ?? "nil"), message: \(error.message ?? "nil")"
            )
        }
    }
    
    func testEmptyDidDocumentVerificationMethodsReturnsDidUnresolvable() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(didDocumentPayload: #"{"verificationMethod":[]}"#)
            )
            
            assertTaxonomy(error, code: entryPoint.didUnresolvableCode, phase: ErrorTaxonomy.phaseDidResolution, kind: entryPoint.requestKind)
            XCTAssertTrue(error.message?.contains("public jwk not found for kid") == true)
        }
    }
    
    func testMissingJwtKidReturnsRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: entryPoint.requestPayload(for: encodedJwtWithoutKid(entryPoint.defaultRequestJwt))
                )
            )
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.message, "JWT kid is missing")
        }
    }
    
    func testJwtKidMissingFromDidDocumentVerificationMethodsReturnsRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let missingVerificationMethodKid = "\(entryPoint.requestDid)#missing-key"
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: entryPoint.requestPayload(for: encodedJwtWithKid(entryPoint.defaultRequestJwt, kid: missingVerificationMethodKid))
                )
            )
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.message, "public jwk not found for kid: \(missingVerificationMethodKid)")
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
            
            assertTaxonomy(error, code: entryPoint.notRegisteredCode, phase: ErrorTaxonomy.phaseRegistrationCheck, kind: entryPoint.requestKind)
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
            
            assertTaxonomy(error, code: entryPoint.requestUnauthorizedCode, phase: ErrorTaxonomy.phaseRequestAuthorization, kind: entryPoint.requestKind)
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
            
            assertTaxonomy(error, code: entryPoint.requestUnauthorizedCode, phase: ErrorTaxonomy.phaseRequestAuthorization, kind: entryPoint.requestKind)
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
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, entryPoint.mismatchErrorCode)
            XCTAssertTrue(router.requestedEndpoints.contains { $0.contains(entryPoint.lastDid) })
        }
    }
    
    func testMalformedDidSyntaxReturnsInvalidLink() {
        entryPoints.forEach { entryPoint in
            ["not-a-did", "did:", "did:example", "did:Example:entity"].forEach { did in
                let deepLink = VCLDeepLink(
                    value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                        "&\(entryPoint.didParam)=\(did)"
                )
                let error = getEntryPointError(entryPoint, deepLink: deepLink)
                
                assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: entryPoint.requestKind)
                XCTAssertEqual(error.sourceErrorCode, VelocityDeepLinkValidator.sourceInvalidOrMissingDid)
            }
        }
    }
    
    func testDidValidationDoesNotUseBacktrackingRegex() {
        entryPoints.forEach { entryPoint in
            let did = "did:example:" + String(repeating: ":", count: 10_000)
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=\(did)"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, entryPoint.mismatchErrorCode)
        }
    }
    
    func testRequestValidationFailuresUseTaxonomyCodes() {
        entryPoints.forEach { entryPoint in
            let deepLink = VCLDeepLink(
                value: "velocity-network://\(entryPoint.schemePath)?request_uri=\(entryPoint.encodedRequestUri)" +
                    "&\(entryPoint.didParam)=did:example:wrong"
            )
            let error = getEntryPointError(entryPoint, deepLink: deepLink)
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, entryPoint.mismatchErrorCode)
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
            
            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.message, "jwt signature verification failed")
        }
    }
    
    private func assertTaxonomy(_ error: VCLError, code: VCLErrorCode, phase: String, kind: String) {
        XCTAssertEqual(error.errorCode, code.rawValue)
        XCTAssertEqual(error.validationPhase, phase)
        XCTAssertEqual(error.requestKind, kind)
    }
    
    private func simpleRequestUri() -> String {
        "https://example.com/request".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    private func encodedJwtWithoutKid(_ encodedJwt: String) -> String {
        var header = jwtHeader(encodedJwt)
        header.removeValue(forKey: VCLJwt.CodingKeys.KeyKid)
        return encodedJwtWithHeader(encodedJwt, header: header)
    }
    
    private func encodedJwtWithKid(_ encodedJwt: String, kid: String) -> String {
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
    
    private func getCredentialManifestDescriptorError(
        descriptor: VCLCredentialManifestDescriptor,
        router: BaselineHttpRouter = BaselineHttpRouter(),
        jwtVerificationResult: VCLResult<Bool> = .success(true)
    ) -> VCLError {
        let vcl = initializedVcl(router: router, jwtVerificationResult: jwtVerificationResult)
        return awaitCredentialManifestError(vcl: vcl, descriptor: descriptor)
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
                ),
                errorCodeCompatibilityMode: .Taxonomy
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
    
    private func awaitCredentialManifest(
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
    
    private func credentialManifestDescriptorByService(
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

private extension ErrorTaxonomyContractTest.EntryPoint {
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
            payload: errorPayload.isEmpty ? nil : errorPayload,
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
