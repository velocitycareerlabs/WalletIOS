//
//  ErrorTaxonomyBackwardCompatibilityBaselineTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ErrorTaxonomyBackwardCompatibilityBaselineTest: ErrorTaxonomyTestCase {
    override var errorCodeCompatibilityMode: VCLErrorCodeCompatibilityMode {
        .Legacy
    }

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
            XCTAssertTrue(error.message?.contains("public jwk not found for kid") == true)
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
                error.message?.contains("public jwk not found for kid") == true,
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

}
