//
//  ErrorTaxonomyContractTest.swift
//  VCLTests
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ErrorTaxonomyContractTest: ErrorTaxonomyTestCase {
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
        let vcl = initializedVcl(router: defaultRouter(.issuing))
        let error = awaitCredentialManifestError(
            vcl: vcl,
            descriptor: credentialManifestDescriptorByService(endpoint: endpoint)
        )

        assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: ErrorTaxonomy.requestKindIssuing)
        XCTAssertEqual(error.sourceErrorCode, VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint)
        XCTAssertEqual(error.requestUri, endpoint)
    }

    func testMissingDirectRequestEndpointReturnsInvalidLink() {
        let vcl = initializedVcl(router: defaultRouter(.issuing))
        let error = awaitCredentialManifestError(
            vcl: vcl,
            descriptor: credentialManifestDescriptorByService(endpoint: "")
        )

        assertTaxonomy(error, code: .InvalidLink, phase: ErrorTaxonomy.phaseLinkValidation, kind: ErrorTaxonomy.requestKindIssuing)
        XCTAssertEqual(error.sourceErrorCode, VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint)
        XCTAssertEqual(error.requestUri, "")
    }

    func testMissingDirectRequestDidReturnsInvalidLink() {
        let vcl = initializedVcl(router: defaultRouter(.issuing))
        let error = awaitCredentialManifestError(
            vcl: vcl,
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

    func testPlainTextRequestEndpointRejectionsReturnClientRequestRejectedWithHttpStatusAndPayloadMessage() {
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

    func testJsonRequestEndpointRejectionsWithoutErrorCodeReturnClientRequestRejected() {
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

    func testEmptyRequestEndpointResponseReturnsIssuerOrVerifierRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "")
            )

            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, "JWT must contain header, payload, and signature")
        }
    }

    func testMalformedRequestEndpointResponseReturnsIssuerOrVerifierRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(requestPayload: "not json")
            )

            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, "JWT must contain header, payload, and signature")
        }
    }

    func testEmptyOrUnextractableRequestPayloadsReturnIssuerOrVerifierRequestInvalid() {
        entryPoints.forEach { entryPoint in
            [
                "{}",
                #"{"unexpected":"value"}"#,
                entryPoint.requestPayload(for: ""),
                entryPoint.requestPayload(value: 123)
            ].forEach { requestPayload in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(requestPayload: requestPayload)
                )

                assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
                XCTAssertEqual(error.sourceErrorCode, VCLErrorCode.SdkError.rawValue)
                XCTAssertEqual(error.message, "JWT must contain header, payload, and signature")
            }
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

    func testDidResolutionNetworkFailurePropagatesDidUnresolvableAndStatusFromNetwork() {
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

    func testInvalidDidDocumentShapeReturnsDidUnresolvable() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(didDocumentPayload: "not json")
            )

            assertTaxonomy(error, code: entryPoint.didUnresolvableCode, phase: ErrorTaxonomy.phaseDidResolution, kind: entryPoint.requestKind)
            XCTAssertTrue(error.message?.contains("public jwk not found for kid") == true)
        }
    }

    func testMissingDidDocumentVerificationMaterialReturnsDidUnresolvable() {
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

    func testMissingJwtIssReturnsRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: entryPoint.requestPayload(for: encodedJwtWithoutIss(entryPoint.defaultRequestJwt))
                )
            )

            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.message, "JWT iss is missing")
        }
    }

    func testMalformedRequestJwtReturnsRequestInvalid() {
        entryPoints.forEach { entryPoint in
            let error = getEntryPointError(
                entryPoint,
                router: defaultRouter(entryPoint).copy(
                    requestPayload: entryPoint.requestPayload(for: "not-a-jwt")
                )
            )

            assertTaxonomy(error, code: entryPoint.requestInvalidCode, phase: ErrorTaxonomy.phaseRequestValidation, kind: entryPoint.requestKind)
            XCTAssertEqual(error.sourceErrorCode, VCLErrorCode.SdkError.rawValue)
            XCTAssertEqual(error.message, "JWT must contain header, payload, and signature")
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

    func testVerifiedProfile404ReturnsIssuerOrVerifierNotRegistered() {
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

    func testVerifiedProfile5xxReturnsRegistrationCheckInconclusive() {
        entryPoints.forEach { entryPoint in
            [500, 503].forEach { statusCode in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(
                        verifiedProfilePayload: #"{"message":"service unavailable","errorCode":"server_error"}"#,
                        verifiedProfileStatusCode: statusCode,
                        verifiedProfileContentType: Request.ContentType.ApplicationJson.rawValue
                    )
                )

                assertTaxonomy(error, code: .RegistrationCheckInconclusive, phase: ErrorTaxonomy.phaseRegistrationCheck, kind: entryPoint.requestKind)
                XCTAssertEqual(error.statusCode, statusCode)
                XCTAssertEqual(error.sourceErrorCode, "server_error")
                XCTAssertEqual(error.message, "service unavailable")
            }
        }
    }

    func testUnexpectedVerifiedProfile4xxReturnsRegistrationCheckInconclusive() {
        entryPoints.forEach { entryPoint in
            [400, 401, 403, 409, 422, 429].forEach { statusCode in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(
                        verifiedProfilePayload: #"{"message":"unexpected profile rejection","errorCode":"profile_rejected"}"#,
                        verifiedProfileStatusCode: statusCode,
                        verifiedProfileContentType: Request.ContentType.ApplicationJson.rawValue
                    )
                )

                assertTaxonomy(error, code: .RegistrationCheckInconclusive, phase: ErrorTaxonomy.phaseRegistrationCheck, kind: entryPoint.requestKind)
                XCTAssertEqual(error.statusCode, statusCode)
                XCTAssertEqual(error.sourceErrorCode, "profile_rejected")
                XCTAssertEqual(error.message, "unexpected profile rejection")
            }
        }
    }

    func testMalformedOrEmptyVerifiedProfile200ReturnsRegistrationCheckInconclusive() {
        [
            "{}",
            "",
            "not json"
        ].forEach { verifiedProfilePayload in
            entryPoints.forEach { entryPoint in
                let error = getEntryPointError(
                    entryPoint,
                    router: defaultRouter(entryPoint).copy(verifiedProfilePayload: verifiedProfilePayload)
                )

                assertTaxonomy(error, code: .RegistrationCheckInconclusive, phase: ErrorTaxonomy.phaseRegistrationCheck, kind: entryPoint.requestKind)
                XCTAssertEqual(error.statusCode, 200)
                XCTAssertEqual(error.sourceErrorCode, VCLErrorCode.SdkError.rawValue)
                XCTAssertEqual(error.message, "Failed to parse verified profile payload.")
            }
        }
    }

    func testWrongIssuerOrVerifierServiceTypeReturnsRequestUnauthorizedWithVerificationStatus() {
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

    func testJwtVerificationFailurePropagatesRequestInvalidFromInjectedJwtService() {
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

}
