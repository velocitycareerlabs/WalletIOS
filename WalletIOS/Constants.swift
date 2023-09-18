//
//  Constants.swift
//  WalletIOS
//
//  Created by Michael Avoyan on 19/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCL

struct Constants  {
    static let PresentationRequestDeepLinkStrDev =
    "velocity-network-devnet://inspect?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Finspect%2Fget-presentation-request%3Fid%3D61efe084b2658481a3d9248c&inspectorDid=did%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D"
    
    static let PresentationRequestDeepLinkStrStaging =
    "velocity-network-testnet://inspect?request_uri=https%3A%2F%2Fstagingagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc&inspectorDid=did%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D"
    
    static let CredentialManifestDeepLinkStrDev =
    "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D6384a3ad148b1991687f67c9%26credential_types%3DEmploymentPastV1.1"
    
    static let CredentialManifestDeepLinkIdentificationStrDev =
    "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevverifagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiAehWmpX5mHBuc93SIhPXF8bsEx68G6mPcdIaLNGbozPA%2Fissue%2Fget-credential-manifest%3FvendorOriginContext%3Dn2KuBU8QgpdmTJ7ZDVWs1"
    
//    One time link
    static let CredentialManifestDeepLinkStrStaging =
    "velocity-network-testnet://issue?request_uri=https%3A%2F%2Fstagingagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA%2Fissue%2Fget-credential-manifest%3Fid%3D624d65daf18484b8525288c3%26credential_types%3DEmploymentPastV1.1"
    
    static let AdamSmithDriversLicenseJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkRyaXZlcnNMaWNlbnNlVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTIxMDMiLCJzdGF0dXNMaXN0SW5kZXgiOjIxMDMsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBSVkxWHdaZzV4cnZvUk5jNE55d3JBcVhrV2pZU05MVTM2dDlQQ0dzbDQ5dz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiZTkwN2Y1NDc2YzU3ZTczNDIzZjFjOWIzOTNiYzFkMGE0ZDU2MjgwYWMxNTUzOTZjYzg3OWYyNDQxYTUyM2NkYyJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9kcml2ZXJzLWxpY2Vuc2UtdjEuMC5zY2hlbWEuanNvbiIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJuYW1lOiI6IkNhbGlmb3JuaWEgRHJpdmVyIExpY2Vuc2UiLCJhdXRob3JpdHkiOnsibmFtZSI6IkNhbGlmb3JuaWEgRE1WIiwicGxhY2UiOnsiYWRkcmVzc1JlZ2lvbiI6IkNBIiwiYWRkcmVzc0NvdW50cnkiOiJVUyJ9fSwidmFsaWRpdHkiOnsidmFsaWRGcm9tIjoiMjAxNS0wMi0wMSIsInZhbGlkVW50aWwiOiIyMDI1LTAxLTMwIn0sImlkZW50aWZpZXIiOiIxMjMxMDMxMjMxMiIsInBlcnNvbiI6eyJnaXZlbk5hbWUiOiJBZGFtIiwiZmFtaWx5TmFtZSI6IlNtaXRoIiwiYmlydGhEYXRlIjoiMTk2Ni0wNi0yMCIsImdlbmRlciI6Ik1hbGUifX19LCJpc3MiOiJkaWQ6aW9uOkVpQWVoV21wWDVtSEJ1YzkzU0loUFhGOGJzRXg2OEc2bVBjZElhTE5HYm96UEEiLCJqdGkiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyIiwiaWF0IjoxNjUyODk2ODY5LCJuYmYiOjE2NTI4OTY4Njl9.DYSJseMcm31Odj7tncT_HBRMs5mknBBRgWuAranmKuY1MPQoBG-A0qOOI9Q3z8X78B7sJISE5iAXBkaVKjUJ2w"
    static let AdamSmithPhoneJwt =
    "eyJ0eXAiOiJKV1QiLCJqd2siOnsiY3J2Ijoic2VjcDI1NmsxIiwieCI6IjFtNi1ZSWtHZTA3MmxYcUNqd1RCTExhMnN6bTZ1cGtMTTNjZnY4eVF6ZEEiLCJ5IjoiNDVBWkJlU2xVOUlSSUR5MHA5RF9kaFR4MkZ4dGQtMlBGdkVma3dsZnRGZyIsImt0eSI6IkVDIiwia2lkIjoiZnV0c2VQQUNRdFVJWnRNVlRMR1RYZzFXMGlUZG1odXJBVHZpcmxES3BwZyIsImFsZyI6IkVTMjU2SyIsInVzZSI6InNpZyJ9LCJhbGciOiJFUzI1NksifQ.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIlBob25lVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdWJqZWN0Ijp7InBob25lIjoiKzE1NTU2MTkyMTkxIn19LCJpc3MiOiJkaWQ6dmVsb2NpdHk6MHhiYTdkODdmOWQ1ZTQ3M2Q3ZDNhODJkMTUyOTIzYWRiNTNkZThmYzBlIiwianRpIjoiZGlkOnZlbG9jaXR5OjB4OGNlMzk4Y2VmNGY3ZWQ4ZWI1MGEyOGQyNWM4NjNlZWY5NjhiYjBlZSIsImlhdCI6MTYzNDUxMDg5NCwibmJmIjoxNjM0NTEwODk0fQ.g3YivH_Quiw95TywvTmiv2CBWsp5JrrCcbpOcTtYpMAQNQJD7Q3kmMYTBs1Zg3tKFRPSJ_XozFIXug5nsn2SGg"
    static let AdamSmithEmailJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo0MTY2I2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkVtYWlsVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTg2OTgiLCJzdGF0dXNMaXN0SW5kZXgiOjg2OTgsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBb3FJWWYycmgxdzEvdURXTnNwYTRyOHRrV2dwRGRUUjBtNHlIRTVMZUtQZz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiODlkNGRjYzg2ZDU0MGM2ZWVhMzlkMTc4ZWVkYzMwMjEzZTc4MmYyNTFlMDNiNzZmNDI3MzEwNjgwOGRkMGQ0ZiJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9lbWFpbC12MS4wLnNjaGVtYS5qc29uIiwidHlwZSI6Ikpzb25TY2hlbWFWYWxpZGF0b3IyMDE4In0sImNyZWRlbnRpYWxTdWJqZWN0Ijp7ImVtYWlsIjoiYWRhbS5zbWl0aEBleGFtcGxlLmNvbSJ9fSwiaXNzIjoiZGlkOmlvbjpFaUFlaFdtcFg1bUhCdWM5M1NJaFBYRjhic0V4NjhHNm1QY2RJYUxOR2JvelBBIiwianRpIjoiZGlkOnZlbG9jaXR5OnYyOjB4NjI1NmIxODkyMWVhYmQzOTM1MWVjMjNmMWM5NGY4ODA2MDRlNzBlNzoyMTE0ODg3MTgzNTUwMDg6NDE2NiIsImlhdCI6MTY1Mjg5Njg2OSwibmJmIjoxNjUyODk2ODY5fQ.fi0qJFzHiDEWTGUu0ME1aG36-j2jm7xxA2DWPs_Ra7ftl-ALMu0FY3A38klbkJQYCaXWHFH0hBbcQ5Z3uZCeew"
    
    //    Credential id is taken from jti field
    static let CredentialId1 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
    static let CredentialId2 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
    static let CredentialIdsToRefresh = [CredentialId1, CredentialId2]
    
    static let IssuingServiceEndPoint =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/get-credential-manifest"

    static let IssuingServiceJsonStr =
        "{\"id\":\"did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"\(IssuingServiceEndPoint)\"}"
    
    static let PresentationSelectionsList = [
        VCLVerifiableCredential(inputDescriptor: "PhoneV1.0", jwtVc: AdamSmithPhoneJwt),
        VCLVerifiableCredential(inputDescriptor: "EmailV1.0", jwtVc: AdamSmithEmailJwt),
        VCLVerifiableCredential(inputDescriptor: "DriversLicenseV1.0", jwtVc: AdamSmithDriversLicenseJwt)
    ]
    
    static let IdentificationList = [
        VCLVerifiableCredential(inputDescriptor: "PhoneV1.0", jwtVc: AdamSmithPhoneJwt),
        VCLVerifiableCredential(inputDescriptor: "EmailV1.0", jwtVc: AdamSmithEmailJwt),
        VCLVerifiableCredential(inputDescriptor: "DriversLicenseV1.0", jwtVc: AdamSmithDriversLicenseJwt)
    ]
    
    static let OrganizationsSearchDescriptor = VCLOrganizationsSearchDescriptor(
        filter: VCLFilter(
//            did: DID,
            serviceTypes: VCLServiceTypes(serviceType: VCLServiceType.Issuer),
            credentialTypes: ["EducationDegree"]
        ),
        page: VCLPage(size: "1", skip: "1"),
        sort: [["createdAt","DESC"], ["pdatedAt", "ASC"]],
        query: "Bank"
    )
    
    // University of Massachusetts Amherst
    static let DidDev = "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"
    static let DidStaging = "did:ion:EiC8GZpBYJXt5UhqxZJbixJyMjrGw0yw8yFN6HjaM1ogSw"
    
    static let OrganizationsSearchDescriptorByDidDev = VCLOrganizationsSearchDescriptor(
        filter: VCLFilter(
            did: DidDev
        )
    )
    static let OrganizationsSearchDescriptorByDidStaging = VCLOrganizationsSearchDescriptor(
        filter: VCLFilter(
            did: DidStaging
        )
    )
    
    static let CredentialTypes = [
        "EducationDegreeRegistrationV1.0",
        "EducationDegreeStudyV1.0",
        "EducationDegreeGraduationV1.0",
        "EmploymentPastV1.1"
    ]
    
    static let ResidentPermitV10 = "ResidentPermitV1.0"
    
    static let VerifiedProfileDescriptor = VCLVerifiedProfileDescriptor(
        did: DidDev
    )
    
    static let SomeJwt = VCLJwt(
        encodedJwt:
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJqd2siOnsia3R5IjoiRUMiLCJjcnYiOiJzZWNwMjU2azEiLCJ4IjoiQ1JFNzc0WV8ydkctdTZka2UwSmQzYVhrd1R4WkE2TV96cDZ2TkR0Vmt5NCIsInkiOiJZLWhIdS1FSXlHSGFRRTdmamxZVVlBZ2lVanFqZFc2VXlIaHI2OVFZTS04IiwidXNlIjoic2lnIn19.eyJwMSI6InYxIiwicDIiOiJ2MTIiLCJuYmYiOjE2OTQ0MzUyMjAsImp0aSI6Ijk4YTc4MGFmLTIyZGYtNGU3ZC1iYTZjLTBmYjE0Njk2Zjg0NSIsImlzcyI6ImlzczEyMyIsInN1YiI6IlpHNXQwT1ZrT08iLCJpYXQiOjE2OTQ0MzUyMjB9.kaEGDsRFjFylIAQ1DDX0GQyWBD1y5rG7WNpFZbrL1DFPrfFgDrydXXOCaBbr8TN81kPrbkscsHUuioY-tGCxMw"
    )
    static let SomePublicJwk = VCLPublicJwk(
        valueStr: "{ \"kty\": \"EC\", \"crv\": \"secp256k1\", \"x\": \"CRE774Y_2vG-u6dke0Jd3aXkwTxZA6M_zp6vNDtVky4\", \"y\": \"Y-hHu-EIyGHaQE7fjlYUYAgiUjqjdW6UyHhr69QYM-8\", \"use\": \"sig\" }"
    )
    static let SomePayload = "{\"p1\":\"v1\", \"p2\":\"v12\"}".toDictionary() ?? [String: Any]()
    
    private static func getServiceBaseUrl(environment: VCLEnvironment) -> String {
        switch environment {
        case VCLEnvironment.Dev:
            return "https://\(VCLEnvironment.Dev.rawValue)walletapi.velocitycareerlabs.io"
        case VCLEnvironment.Qa:
            return "https://\(VCLEnvironment.Qa.rawValue)walletapi.velocitycareerlabs.io"
        case VCLEnvironment.Staging:
            return "https://\(VCLEnvironment.Staging.rawValue)walletapi.velocitycareerlabs.io"
        default: // prod
            return "https://walletapi.velocitycareerlabs.io"
        }
    }
    static func getJwtSignServiceUrl(environment: VCLEnvironment) -> String {
        return  "\(getServiceBaseUrl(environment: environment))/jwt/sign"
    }
    static func getJwtVerifyServiceUrl(environment: VCLEnvironment) -> String {
        return  "\(getServiceBaseUrl(environment: environment))/jwt/verify"
    }
    static func getJwtDecodeServiceUrl(environment: VCLEnvironment) -> String {
        return  "\(getServiceBaseUrl(environment: environment))/jwt/decode"
    }
    static func getCreateDidKeyServiceUrl(environment: VCLEnvironment) -> String {
        return  "\(getServiceBaseUrl(environment: environment))/create_did_key"
    }
}
