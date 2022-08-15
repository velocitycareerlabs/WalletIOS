//
//  OrganizationsMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 01/07/2021.
//

import Foundation

class OrganizationsMocks {
    static let OrganizationJson =
        "{\"id\":\"did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3\",\"name\":\"Universidad de Sant Cugat\",\"logo\":\"https:\\/\\/docs.velocitycareerlabs.io\\/Logos\\/Universidad de  Sant Cugat.png\",\"location\":{\"countryCode\":\"ES\",\"regionCode\":\"CAT\"},\"founded\":\"1984\",\"website\":\"https:\\/\\/example.com\",\"permittedVelocityServiceCategories\":[\"Issuer\",null],\"service\":[{\"id\":\"did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"https:\\/\\/devagent.velocitycareerlabs.io\\/api\\/holder\\/v0.6\\/org\\/did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3\\/issue\\/get-credential-manifest\"}]}"
    static let OrganizationJsonResult = "{\"result\":[\(OrganizationJson)]}"

    static let IssuingServiceJsonStr =
        "{\"id\":\"did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"https:\\/\\/devagent.velocitycareerlabs.io\\/api\\/holder\\/v0.6\\/org\\/did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3\\/issue\\/get-credential-manifest\"}"
    static let IssuingServiceEndpoint =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3/issue/get-credential-manifest"
}
