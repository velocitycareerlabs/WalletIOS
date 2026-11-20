//
//  VCLDeepLinkProducedLinksTest.swift
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

// Links as the Credentialing Hub, the credential agent and the holder app produce them, and what the SDK reads from
// each today. The request URI is compared as a server reads it: split at `&`, then at the first `=`, with each part
// form-decoded, in any order. Comments starting "Should be fixed" mark behaviour that is wrong today.
final class VCLDeepLinkProducedLinksTest: XCTestCase {

    private struct Case {
        let name: String
        let link: String
        let did: String?
        let vendorOriginContext: String?
        let requestUri: String?
        let query: [(String, String)]
    }

    private let cases: [Case] = [
        // Each credential_types value of the request URI is kept.
        Case(
            name: "Hub depot issuing link with four credential types",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevcih.velocitycareerlabs.io%2Fvn-api%2Fr%2Fdid%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com%2Fget-credential-manifest%3Fid%3D65f0c0ffee0000000000e1f2%26credential_types%3DPassportV1.0%26credential_types%3DNationalIdCardV1.0%26credential_types%3DDriversLicenseV1.0%26credential_types%3DIdDocumentV1.0&issuerDid=did%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com&vendorOriginContext=depot%3A65f0c0ffee0000000000d3a1%3AaB3-x_Y9zQ0-k_L7",
            did: "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com",
            vendorOriginContext: "depot:65f0c0ffee0000000000d3a1:aB3-x_Y9zQ0-k_L7",
            requestUri: "https://devcih.velocitycareerlabs.io/vn-api/r/did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com/get-credential-manifest",
            query: [
                ("credential_types", "DriversLicenseV1.0"),
                ("credential_types", "IdDocumentV1.0"),
                ("credential_types", "NationalIdCardV1.0"),
                ("credential_types", "PassportV1.0"),
                ("id", "65f0c0ffee0000000000e1f2"),
                ("issuerDid", "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com"),
                ("vendorOriginContext", "depot:65f0c0ffee0000000000d3a1:aB3-x_Y9zQ0-k_L7")
            ]
        ),
        Case(
            name: "Hub depot issuing link with no credential types",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevcih.velocitycareerlabs.io%2Fvn-api%2Fr%2Fdid%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com%2Fget-credential-manifest%3Fid%3D65f0c0ffee0000000000e1f2&issuerDid=did%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com&vendorOriginContext=depot%3A65f0c0ffee0000000000d3a1%3AaB3-x_Y9zQ0-k_L7",
            did: "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com",
            vendorOriginContext: "depot:65f0c0ffee0000000000d3a1:aB3-x_Y9zQ0-k_L7",
            requestUri: "https://devcih.velocitycareerlabs.io/vn-api/r/did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com/get-credential-manifest",
            query: [
                ("id", "65f0c0ffee0000000000e1f2"),
                ("issuerDid", "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com"),
                ("vendorOriginContext", "depot:65f0c0ffee0000000000d3a1:aB3-x_Y9zQ0-k_L7")
            ]
        ),
        Case(
            name: "Hub shared issuing link, without depot, credential types or vendorOriginContext",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevcih.velocitycareerlabs.io%2Fvn-api%2Fr%2Fdid%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com%2Fget-credential-manifest%3Fid%3D65f0c0ffee0000000000e1f2&issuerDid=did%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com",
            did: "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com",
            vendorOriginContext: nil,
            requestUri: "https://devcih.velocitycareerlabs.io/vn-api/r/did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com/get-credential-manifest",
            query: [
                ("id", "65f0c0ffee0000000000e1f2"),
                ("issuerDid", "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com")
            ]
        ),
        Case(
            name: "Hub depot presentation link",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevcih.velocitycareerlabs.io%2Fvn-api%2Fr%2Fdid%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com%2Fget-presentation-request%3Fid%3D65f0c0ffee0000000000e1f2&inspectorDid=did%3Aweb%3Adevregistrar.velocitynetwork.foundation%3Ad%3Aexample-issuer.com&vendorOriginContext=depot%3A65f0c0ffee0000000000d3a1",
            did: "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com",
            vendorOriginContext: "depot:65f0c0ffee0000000000d3a1",
            requestUri: "https://devcih.velocitycareerlabs.io/vn-api/r/did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com/get-presentation-request",
            query: [
                ("id", "65f0c0ffee0000000000e1f2"),
                ("inspectorDid", "did:web:devregistrar.velocitynetwork.foundation:d:example-issuer.com"),
                ("vendorOriginContext", "depot:65f0c0ffee0000000000d3a1")
            ]
        ),
        Case(
            name: "Agent exchange issuing link",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6630aa11bb22cc33dd44ee55%26exchange_id%3D6630ff00ee11dd22cc33bb44%26credential_types%3DPastEmploymentPosition&issuerDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=abc123",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "abc123",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest",
            query: [
                ("credential_types", "PastEmploymentPosition"),
                ("exchange_id", "6630ff00ee11dd22cc33bb44"),
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("issuerDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "abc123")
            ]
        ),
        // The page leaves out issuerDid, so the DID comes from the request URI's path.
        Case(
            name: "Agent issuing link rebuilt by the agent's /app-redirect page",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6630aa11bb22cc33dd44ee55%26exchange_id%3D6630ff00ee11dd22cc33bb44%26credential_types%3DPastEmploymentPosition&vendorOriginContext=abc123",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "abc123",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest",
            query: [
                ("credential_types", "PastEmploymentPosition"),
                ("exchange_id", "6630ff00ee11dd22cc33bb44"),
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("vendorOriginContext", "abc123")
            ]
        ),
        // The agent repeats EmailV1.0. The request URI carries it once.
        Case(
            name: "Agent exchange issuing link with two credential types",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6630aa11bb22cc33dd44ee55%26exchange_id%3D6630ff00ee11dd22cc33bb44%26credential_types%3DEmailV1.0%26credential_types%3DPhoneV1.0%26credential_types%3DEmailV1.0&issuerDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=abc123",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "abc123",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest",
            query: [
                ("credential_types", "EmailV1.0"),
                ("credential_types", "PhoneV1.0"),
                ("exchange_id", "6630ff00ee11dd22cc33bb44"),
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("issuerDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "abc123")
            ]
        ),
        Case(
            name: "Agent disclosure issuing link without vendorOriginContext",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6630aa11bb22cc33dd44ee55&issuerDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: nil,
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("issuerDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA")
            ]
        ),
        Case(
            name: "Agent presentation link from a did:web inspector",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aweb%3Aexample.com%3Aissuers%3Aacme%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aweb%3Aexample.com%3Aissuers%3Aacme&vendorOriginContext=abc123",
            did: "did:web:example.com:issuers:acme",
            vendorOriginContext: "abc123",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:web:example.com:issuers:acme/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:web:example.com:issuers:acme"),
                ("vendorOriginContext", "abc123")
            ]
        ),
        Case(
            name: "vendorOriginContext with JSON",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22%2C%22KeyCode%22%3A%2254514480%22%7D%2C%22Token%22%3A%22832077a4%22%7D",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "{\"SubjectKey\":{\"BusinessUnit\":\"ZC\",\"KeyCode\":\"54514480\"},\"Token\":\"832077a4\"}",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "{\"SubjectKey\":{\"BusinessUnit\":\"ZC\",\"KeyCode\":\"54514480\"},\"Token\":\"832077a4\"}")
            ]
        ),
        Case(
            name: "vendorOriginContext with commas",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=a%2Cb%2Cc",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "a,b,c",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "a,b,c")
            ]
        ),
        // Should be fixed: the request URI's copy leaves `+` unescaped, so a server reads it as a space. Only the
        // hub's presentation route reads vendorOriginContext from the request URI, and hub values have no `+`.
        Case(
            name: "vendorOriginContext with base64 = padding",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=dGVzdA%2B%2Fx9Q%3D%3D",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "dGVzdA+/x9Q==",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "dGVzdA /x9Q==")
            ]
        ),
        // Should be fixed: the value is cut at `?`, and `a=1` and `b=2` become parameters of the request URI. The
        // link is decoded before it's split at `?` and `&`.
        Case(
            name: "vendorOriginContext with ? and &",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=https%3A%2F%2Fexample.com%2Fcb%3Fa%3D1%26b%3D2",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "https://example.com/cb",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("a", "1"),
                ("b", "2"),
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "https://example.com/cb")
            ]
        ),
        // Should be fixed: iOS doesn't decode the `+` that encodes the space, so vendorOriginContext keeps it.
        Case(
            name: "vendorOriginContext with a space",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=John+Smith",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "John+Smith",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "John Smith")
            ]
        ),
        // Should be fixed: iOS doesn't decode the `+` that encodes the space, so vendorOriginContext keeps it.
        Case(
            name: "vendorOriginContext with % and a space",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=100%25+done",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "100%+done",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "100% done")
            ]
        ),
        // Should be fixed: iOS doesn't decode the `+` that encodes the space, so vendorOriginContext keeps it.
        Case(
            name: "vendorOriginContext with accented letters and a space",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=Jos%C3%A9+M%C3%BCller",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "José+Müller",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "José Müller")
            ]
        ),
        // Should be fixed: iOS reads nil where Android reads an empty string, because Swift's split drops the
        // empty value after `=`.
        Case(
            name: "Empty vendorOriginContext",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: nil,
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA")
            ]
        ),
        Case(
            name: "vendorOriginContext with #",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=order%23123",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "order#123",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "order#123")
            ]
        ),
        // Should be fixed: the request URI's copy leaves `+` unescaped, so a server reads it as a space. Only the
        // hub's presentation route reads vendorOriginContext from the request URI, and hub values have no `+`.
        Case(
            name: "vendorOriginContext with an email address with +",
            link: "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Finspect%2Fget-presentation-request%3Fid%3D6630aa11bb22cc33dd44ee55&inspectorDid=did%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA&vendorOriginContext=jane.doe%2Bwallet%40example.com",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "jane.doe+wallet@example.com",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/inspect/get-presentation-request",
            query: [
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("inspectorDid", "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"),
                ("vendorOriginContext", "jane.doe wallet@example.com")
            ]
        ),
        Case(
            name: "Holder app issuing-sequence part, passed without the scheme",
            link: "issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6630aa11bb22cc33dd44ee55%26exchange_id%3D6630ff00ee11dd22cc33bb99%26credential_types%3DPhoneV1.0&vendorOriginContext=second-ctx",
            did: "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA",
            vendorOriginContext: "second-ctx",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest",
            query: [
                ("credential_types", "PhoneV1.0"),
                ("exchange_id", "6630ff00ee11dd22cc33bb99"),
                ("id", "6630aa11bb22cc33dd44ee55"),
                ("vendorOriginContext", "second-ctx")
            ]
        ),
        // The app relies on this. The SDK finds vendorOriginContext inside request_uri because it decodes the
        // whole link before splitting it.
        Case(
            name: "Holder app email/phone verification link, with vendorOriginContext inside request_uri",
            link: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Fissue%2Fget-credential-manifest%3FvendorOriginContext%3DeyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.abc-_def",
            did: "did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692",
            vendorOriginContext: "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.abc-_def",
            requestUri: "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692/issue/get-credential-manifest",
            query: [
                ("vendorOriginContext", "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.abc-_def")
            ]
        )
    ]

    func testProducedLinks() {
        var mismatches: [String] = []
        for testCase in cases {
            let deepLink = VCLDeepLink(value: testCase.link)
            let requestUri: String? = deepLink.requestUri?.components(separatedBy: "?").first
            check(&mismatches, testCase.name, "did", testCase.did, deepLink.did)
            check(&mismatches, testCase.name, "vendorOriginContext", testCase.vendorOriginContext, deepLink.vendorOriginContext)
            check(&mismatches, testCase.name, "request URI", testCase.requestUri, requestUri)
            check(&mismatches, testCase.name, "request URI query", sorted(testCase.query), serverQuery(deepLink.requestUri))
        }
        XCTAssertEqual(mismatches.joined(separator: "\n"), "")
    }

    private func check(_ mismatches: inout [String], _ name: String, _ what: String, _ expected: String?, _ actual: String?) {
        if expected != actual {
            mismatches.append("\(name): \(what) is \(actual ?? "nil"), expected \(expected ?? "nil")")
        }
    }

    private func sorted(_ pairs: [(String, String)]) -> String {
        let items: [String] = pairs.map { pair in "\(pair.0)=\(pair.1)" }
        return items.sorted().joined(separator: " & ")
    }

    private func serverQuery(_ uri: String?) -> String {
        guard let uri = uri, let start = uri.firstIndex(of: "?") else { return "" }
        let query: String = String(uri[uri.index(after: start)...])
        var pairs: [(String, String)] = []
        for item in query.components(separatedBy: "&") where !item.isEmpty {
            if let separator = item.firstIndex(of: "=") {
                let name: String = String(item[..<separator])
                let value: String = String(item[item.index(after: separator)...])
                pairs.append((formDecode(name), formDecode(value)))
            } else {
                pairs.append((formDecode(item), ""))
            }
        }
        return sorted(pairs)
    }

    private func formDecode(_ value: String) -> String {
        return value.replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? value
    }
}
