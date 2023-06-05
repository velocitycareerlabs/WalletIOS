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
    
    static let CredentialManifestDeepLinkStrStaging =
    "velocity-network-testnet://issue?request_uri=https%3A%2F%2Fstagingagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA%2Fissue%2Fget-credential-manifest%3Fid%3D624d65daf18484b8525288c3%26credential_types%3DEmploymentPastV1.1"
    
    static let AdamSmithDriversLicenseJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkRyaXZlcnNMaWNlbnNlVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTIxMDMiLCJzdGF0dXNMaXN0SW5kZXgiOjIxMDMsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBSVkxWHdaZzV4cnZvUk5jNE55d3JBcVhrV2pZU05MVTM2dDlQQ0dzbDQ5dz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiZTkwN2Y1NDc2YzU3ZTczNDIzZjFjOWIzOTNiYzFkMGE0ZDU2MjgwYWMxNTUzOTZjYzg3OWYyNDQxYTUyM2NkYyJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9kcml2ZXJzLWxpY2Vuc2UtdjEuMC5zY2hlbWEuanNvbiIsInR5cGUiOiJKc29uU2NoZW1hVmFsaWRhdG9yMjAxOCJ9LCJjcmVkZW50aWFsU3ViamVjdCI6eyJuYW1lOiI6IkNhbGlmb3JuaWEgRHJpdmVyIExpY2Vuc2UiLCJhdXRob3JpdHkiOnsibmFtZSI6IkNhbGlmb3JuaWEgRE1WIiwicGxhY2UiOnsiYWRkcmVzc1JlZ2lvbiI6IkNBIiwiYWRkcmVzc0NvdW50cnkiOiJVUyJ9fSwidmFsaWRpdHkiOnsidmFsaWRGcm9tIjoiMjAxNS0wMi0wMSIsInZhbGlkVW50aWwiOiIyMDI1LTAxLTMwIn0sImlkZW50aWZpZXIiOiIxMjMxMDMxMjMxMiIsInBlcnNvbiI6eyJnaXZlbk5hbWUiOiJBZGFtIiwiZmFtaWx5TmFtZSI6IlNtaXRoIiwiYmlydGhEYXRlIjoiMTk2Ni0wNi0yMCIsImdlbmRlciI6Ik1hbGUifX19LCJpc3MiOiJkaWQ6aW9uOkVpQWVoV21wWDVtSEJ1YzkzU0loUFhGOGJzRXg2OEc2bVBjZElhTE5HYm96UEEiLCJqdGkiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo2NzYyIiwiaWF0IjoxNjUyODk2ODY5LCJuYmYiOjE2NTI4OTY4Njl9.DYSJseMcm31Odj7tncT_HBRMs5mknBBRgWuAranmKuY1MPQoBG-A0qOOI9Q3z8X78B7sJISE5iAXBkaVKjUJ2w"
    static let AdamSmithPhoneJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo5MTg1I2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.ewogICJ2YyI6IHsKICAgICJAY29udGV4dCI6IFsKICAgICAgImh0dHBzOi8vd3d3LnczLm9yZy8yMDE4L2NyZWRlbnRpYWxzL3YxIgogICAgXSwKICAgICJ0eXBlIjogWwogICAgICAiUGhvbmVWMS4wIiwKICAgICAgIlZlcmlmaWFibGVDcmVkZW50aWFsIgogICAgXSwKICAgICJjcmVkZW50aWFsU3RhdHVzIjogewogICAgICAidHlwZSI6ICJWZWxvY2l0eVJldm9jYXRpb25MaXN0SmFuMjAyMSIsCiAgICAgICJpZCI6ICJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTU3OTkiLAogICAgICAic3RhdHVzTGlzdEluZGV4IjogNTc5OSwKICAgICAgInN0YXR1c0xpc3RDcmVkZW50aWFsIjogImV0aGVyZXVtOjB4RDg5MEYyRDYwQjQyOWY5ZTI1N0ZDMEJjNThFZjIyMzc3NzZERDkxQi9nZXRSZXZva2VkU3RhdHVzP2FkZHJlc3M9MHgwMzAxOEUzYTM4OTczNGFFMTJmMTRFNDQ1NDBmQWVhMzU3OTFmRUM3Jmxpc3RJZD0xNjM1Nzg4NjYyOTY2NTMiLAogICAgICAibGlua0NvZGVDb21taXQiOiAiRWlCaXlISE1LRlkwYW1rK3gvVGxtN2liY2tsbk8wbHMySEh1ckozN09WRDBJZz09IgogICAgfSwKICAgICJjb250ZW50SGFzaCI6IHsKICAgICAgInR5cGUiOiAiVmVsb2NpdHlDb250ZW50SGFzaDIwMjAiLAogICAgICAidmFsdWUiOiAiNGYwMjUyYzRlMTI4ZTZkMzE5N2NlYTA3Yjc2ZmNiYWExMjZkZTNkNDBiZjY1NzlkZmE1MzQ1ZTVjZjFhOGZiMiIKICAgIH0sCiAgICAiY3JlZGVudGlhbFNjaGVtYSI6IHsKICAgICAgImlkIjogImh0dHBzOi8vZGV2cmVnaXN0cmFyLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvcGhvbmUtdjEuMC5zY2hlbWEuanNvbiIsCiAgICAgICJ0eXBlIjogIkpzb25TY2hlbWFWYWxpZGF0b3IyMDE4IgogICAgfSwKICAgICJjcmVkZW50aWFsU3ViamVjdCI6IHsKICAgICAgInBob25lIjogIisxNTU1NjE5MjE5MSIsCiAgICAgICJmb28iOiAiZm9vIgogICAgfQogIH0sCiAgImlzcyI6ICJkaWQ6aW9uOkVpQWVoV21wWDVtSEJ1YzkzU0loUFhGOGJzRXg2OEc2bVBjZElhTE5HYm96UEEiLAogICJqdGkiOiAiZGlkOnZlbG9jaXR5OnYyOjB4NjI1NmIxODkyMWVhYmQzOTM1MWVjMjNmMWM5NGY4ODA2MDRlNzBlNzoyMTE0ODg3MTgzNTUwMDg6OTE4NSIsCiAgImlhdCI6IDE2NTI4OTY4NjksCiAgIm5iZiI6IDE2NTI4OTY4NjkKfQ.aiiqintVpgfn1GpSJG8lSRlLqr2K0rfylXDd92ryzBgLEsS-8CbFngNHIHJYW9SVgiJYXcPv6f0YZMk78cYPtw"
    static let AdamSmithEmailJwt =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6djI6MHg2MjU2YjE4OTIxZWFiZDM5MzUxZWMyM2YxYzk0Zjg4MDYwNGU3MGU3OjIxMTQ4ODcxODM1NTAwODo0MTY2I2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJ2YyI6eyJAY29udGV4dCI6WyJodHRwczovL3d3dy53My5vcmcvMjAxOC9jcmVkZW50aWFscy92MSJdLCJ0eXBlIjpbIkVtYWlsVjEuMCIsIlZlcmlmaWFibGVDcmVkZW50aWFsIl0sImNyZWRlbnRpYWxTdGF0dXMiOnsidHlwZSI6IlZlbG9jaXR5UmV2b2NhdGlvbkxpc3RKYW4yMDIxIiwiaWQiOiJldGhlcmV1bToweEQ4OTBGMkQ2MEI0MjlmOWUyNTdGQzBCYzU4RWYyMjM3Nzc2REQ5MUIvZ2V0UmV2b2tlZFN0YXR1cz9hZGRyZXNzPTB4MDMwMThFM2EzODk3MzRhRTEyZjE0RTQ0NTQwZkFlYTM1NzkxZkVDNyZsaXN0SWQ9MTYzNTc4ODY2Mjk2NjUzJmluZGV4PTg2OTgiLCJzdGF0dXNMaXN0SW5kZXgiOjg2OTgsInN0YXR1c0xpc3RDcmVkZW50aWFsIjoiZXRoZXJldW06MHhEODkwRjJENjBCNDI5ZjllMjU3RkMwQmM1OEVmMjIzNzc3NkREOTFCL2dldFJldm9rZWRTdGF0dXM_YWRkcmVzcz0weDAzMDE4RTNhMzg5NzM0YUUxMmYxNEU0NDU0MGZBZWEzNTc5MWZFQzcmbGlzdElkPTE2MzU3ODg2NjI5NjY1MyIsImxpbmtDb2RlQ29tbWl0IjoiRWlBb3FJWWYycmgxdzEvdURXTnNwYTRyOHRrV2dwRGRUUjBtNHlIRTVMZUtQZz09In0sImNvbnRlbnRIYXNoIjp7InR5cGUiOiJWZWxvY2l0eUNvbnRlbnRIYXNoMjAyMCIsInZhbHVlIjoiODlkNGRjYzg2ZDU0MGM2ZWVhMzlkMTc4ZWVkYzMwMjEzZTc4MmYyNTFlMDNiNzZmNDI3MzEwNjgwOGRkMGQ0ZiJ9LCJjcmVkZW50aWFsU2NoZW1hIjp7ImlkIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9lbWFpbC12MS4wLnNjaGVtYS5qc29uIiwidHlwZSI6Ikpzb25TY2hlbWFWYWxpZGF0b3IyMDE4In0sImNyZWRlbnRpYWxTdWJqZWN0Ijp7ImVtYWlsIjoiYWRhbS5zbWl0aEBleGFtcGxlLmNvbSJ9fSwiaXNzIjoiZGlkOmlvbjpFaUFlaFdtcFg1bUhCdWM5M1NJaFBYRjhic0V4NjhHNm1QY2RJYUxOR2JvelBBIiwianRpIjoiZGlkOnZlbG9jaXR5OnYyOjB4NjI1NmIxODkyMWVhYmQzOTM1MWVjMjNmMWM5NGY4ODA2MDRlNzBlNzoyMTE0ODg3MTgzNTUwMDg6NDE2NiIsImlhdCI6MTY1Mjg5Njg2OSwibmJmIjoxNjUyODk2ODY5fQ.fi0qJFzHiDEWTGUu0ME1aG36-j2jm7xxA2DWPs_Ra7ftl-ALMu0FY3A38klbkJQYCaXWHFH0hBbcQ5Z3uZCeew"
    
    //    Credential id is taken from jti field
    static let CredentialId1 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
    static let CredentialId2 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
    static let CredentialIdsToRefresh = [CredentialId1, CredentialId2]
    
    static let IssuingServiceEndPoint =
    "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3/issue/get-credential-manifest"
    
    static let IssuingServiceJsonStr =
    "{\"id\":\"did:velocity:0x571cf9ef33b111b7060942eb43133c0b347c7ca3#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"\(IssuingServiceEndPoint)\"}"
    
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
    
    static let DidDev = "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw"
    static let DidStaging = "did:ion:EiDaeg3OofbDCdaQi5-zOLGfhZ9-boS0-w5URDfVwrI7BQ"
    
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
    
    static let OrganizationJson = "   {\n" +
    "      \"name\":\"Association of Chartered Certified Accountants\",\n" +
    "      \"location\":{\n" +
    "         \"countryCode\":\"UK\",\n" +
    "         \"regionCode\":\"ENG\"\n" +
    "      },\n" +
    "      \"logo\":\"https:\\/\\/docs.velocitycareerlabs.io\\/Logos\\/ACCA.png\",\n" +
    "      \"website\":\"https:\\/\\/example.com\",\n" +
    "      \"founded\":\"1904\",\n" +
    "      \"permittedVelocityServiceCategories\":[\n" +
    "         \"\",\n" +
    "         \"Issuer\"\n" +
    "      ],\n" +
    "      \"did\":\"did:velocity:0x5b4a5d2fdfdbd34e73904a0c8022ed4c22136add\"\n" +
    "   }"
    
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
            "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6MHhkNGRmMjk3MjZkNTAwZjliODViYzZjN2YxYjNjMDIxZjE2MzA1NjkyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJleGNoYW5nZV9pZCI6IjYxMmYzM2Q1OTRhN2IyMDAwYTExZDM3YiIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiTWljcm9zb2Z0IENvcnBvcmF0aW9uIiwibG9nb191cmkiOiJodHRwczovL2Fnc29sLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxOC8wOS9uZXctbWljcm9zb2Z0LWxvZ28tU0laRUQtU1FVQVJFLmpwZyIsInRvc191cmkiOiJodHRwczovL3d3dy52ZWxvY2l0eWV4cGVyaWVuY2VjZW50ZXIuY29tL3Rlcm1zLWFuZC1jb25kaXRpb25zLXZuZiIsIm1heF9yZXRlbnRpb25fcGVyaW9kIjoiMm0iLCJwcm9ncmVzc191cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIvZ2V0LWV4Y2hhbmdlLXByb2dyZXNzIiwic3VibWl0X3ByZXNlbnRhdGlvbl91cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIvaXNzdWUvc3VibWl0LWlkZW50aWZpY2F0aW9uIiwiY2hlY2tfb2ZmZXJzX3VyaSI6Imh0dHBzOi8vZGV2YWdlbnQudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS9ob2xkZXIvdjAuNi9vcmcvZGlkOnZlbG9jaXR5OjB4ZDRkZjI5NzI2ZDUwMGY5Yjg1YmM2YzdmMWIzYzAyMWYxNjMwNTY5Mi9pc3N1ZS9jcmVkZW50aWFsLW9mZmVycyIsImZpbmFsaXplX29mZmVyc191cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIvaXNzdWUvZmluYWxpemUtb2ZmZXJzIn0sInByZXNlbnRhdGlvbl9kZWZpbml0aW9uIjp7ImlkIjoiNjEyZjMzZDU5NGE3YjIwMDBhMTFkMzdiLjYwZTgwZGY5MGY5YjhlMDAxYzY4ZmMzMyIsInB1cnBvc2UiOiJDcmVkZW50aWFsIElzc3VhbmNlIiwiZm9ybWF0Ijp7Imp3dF92cCI6eyJhbGciOlsic2VjcDI1NmsxIl19fSwiaW5wdXRfZGVzY3JpcHRvcnMiOlt7ImlkIjoiUGhvbmUiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvcGhvbmUuc2NoZW1hLmpzb24ifV19LHsiaWQiOiJFbWFpbCIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9lbWFpbC5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IklkRG9jdW1lbnQiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvaWQtZG9jdW1lbnQudjEuc2NoZW1hLmpzb24ifV19XX0sIm91dHB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJQYXN0RW1wbG95bWVudFBvc2l0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL3Bhc3QtZW1wbG95bWVudC1wb3NpdGlvbi5zY2hlbWEuanNvbiJ9XX1dLCJpc3N1ZXIiOnsiaWQiOiJkaWQ6dmVsb2NpdHk6MHhkNGRmMjk3MjZkNTAwZjliODViYzZjN2YxYjNjMDIxZjE2MzA1NjkyIn0sImlzcyI6ImRpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIiLCJpYXQiOjE2MzA0ODM0MTMsImV4cCI6MTYzMTA4ODIxMywibmJmIjoxNjMwNDgzNDEzfQ.9py7xxe60rFa_kpbG7OptU8ekKgLJGSiMfQctNvHctclPiqvnuZ-Bh1jjN0rh7V5yqFpvz8wqPTD-4Rs_1zIGg"
    )
    static let SomeJwkPublic = VCLJwkPublic(
        valueStr:
            "{\"alg\":\"ES256K\",\"use\":\"sig\",\"kid\":\"uemn6l5ro6hLNrgiPRl1Dy51V9whez4tu4hlwsNOTVk\",\"crv\":\"secp256k1\",\"x\":\"oLYCa-AlnVpW8Rq9iST_1eY_XoyvGRry7y1xS4vU4qo\",\"y\":\"PUMAsawZ24WaSnRIdDb_wNbShAvfsGF71ke1DcJGxlM\",\"kty\":\"EC\"}"
    )
    static let SomePayload = "{\"p1\":\"v1\", \"p2\":\"v12\"}".toDictionary() ?? [String: Any]()
}
