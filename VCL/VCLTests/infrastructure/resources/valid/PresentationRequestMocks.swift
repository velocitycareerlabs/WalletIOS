//
//  PresentationRequestMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 04/05/2021.
//

import Foundation
@testable import VCL

class PresentationRequestMocks {
    static let EncodedPresentationRequest =         "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6MHhkNGRmMjk3MjZkNTAwZjliODViYzZjN2YxYjNjMDIxZjE2MzA1NjkyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJleGNoYW5nZV9pZCI6IjYwZWMxZjc2NmQyNzRlMDAwODY3NDhjYSIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiTWljcm9zb2Z0IENvcnBvcmF0aW9uIiwibG9nb191cmkiOiJodHRwczovL2Fnc29sLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxOC8wOS9uZXctbWljcm9zb2Z0LWxvZ28tU0laRUQtU1FVQVJFLmpwZyIsInRvc191cmkiOiJodHRwczovL3d3dy52ZWxvY2l0eWV4cGVyaWVuY2VjZW50ZXIuY29tL3Rlcm1zLWFuZC1jb25kaXRpb25zLXZuZiIsIm1heF9yZXRlbnRpb25fcGVyaW9kIjoiNm0ifSwicHJlc2VudGF0aW9uX2RlZmluaXRpb24iOnsiaWQiOiI2MGVjMWY3NjZkMjc0ZTAwMDg2NzQ4Y2EuNjBlYzE0M2U2ZDI3NGUwMDA4Njc0OGJjIiwicHVycG9zZSI6IklkIENoZWNrIiwiZm9ybWF0Ijp7Imp3dF92cCI6eyJhbGciOlsic2VjcDI1NmsxIl19fSwiaW5wdXRfZGVzY3JpcHRvcnMiOlt7ImlkIjoiSWREb2N1bWVudCIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9pZC1kb2N1bWVudC52MS5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IkVtYWlsIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL2VtYWlsLnNjaGVtYS5qc29uIn1dfSx7ImlkIjoiUGhvbmUiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvcGhvbmUuc2NoZW1hLmpzb24ifV19LHsiaWQiOiJQYXN0RW1wbG95bWVudFBvc2l0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL3Bhc3QtZW1wbG95bWVudC1wb3NpdGlvbi5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IkN1cnJlbnRFbXBsb3ltZW50UG9zaXRpb24iLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2c2VydmljZXMudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS92MC42L3NjaGVtYXMvY3VycmVudC1lbXBsb3ltZW50LXBvc2l0aW9uLnNjaGVtYS5qc29uIn1dfSx7ImlkIjoiRWR1Y2F0aW9uRGVncmVlIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL2VkdWNhdGlvbi1kZWdyZWUuc2NoZW1hLmpzb24ifV19XX0sImlzcyI6ImRpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIiLCJpYXQiOjE2MjYwODcyODYsImV4cCI6MTYyNjY5MjA4NiwibmJmIjoxNjI2MDg3Mjg2fQ.BSQnMNNJyicCsh6zeh7k5GBHC6T9QgPNV4SHhSXsnz3sBJMwNBFz7v4axLCoCiKHtIxNj5-bJ5ggI3wF6UVDeQ"
    
    static let EncodedPresentationRequestResponse =
        "{\"presentation_request\":\"\(EncodedPresentationRequest)\"}"
    
    static let PresentationRequestJwtDecodedJson = "{\"payload\":{\"exchange_id\":\"6092492cc41813579fb49ada\",\"metadata\":{\"client_name\":\"Google\",\"logo_uri\":\"https://expresswriters.com/wp-content/uploads/2015/09/google-new-logo-1280x720.jpg\",\"tos_uri\":\"https://requisitions.acme.example.com/disclosure-terms.html\",\"max_retention_period\":\"2m\"},\"presentation_definition\":{\"id\":\"6092492cc41813579fb49ada.5f4d7ec9461170000749cf75\",\"purpose\":\"Job offer\",\"format\":{\"jwt_vp\":{\"alg\":[\"secp256k1\"]}},\"input_descriptors\":[{\"id\":\"IdentityAndContact\",\"schema\":[{\"uri\":\"IdentityAndContact\"}]},{\"id\":\"EducationDegree\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/education-degree.schema.json\"}]},{\"id\":\"PastEmploymentPosition\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/past-employment-position.schema.json\"}]},{\"id\":\"CurrentEmploymentPosition\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/current-employment-position.schema.json\"}]},{\"id\":\"Certification\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/certification.schema.json\"}]},{\"id\":\"Badge\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/badge.schema.json\"}]},{\"id\":\"Assessment\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/assessment.schema.json\"}]}]},\"iss\":\"did:velocity:0xd60231a3d0de0f197f1784f6f37ebcfaa291ab23\",\"iat\":1620199724,\"exp\":1620804524,\"nbf\":1620199724},\"header\":{\"typ\":\"JWT\",\"kid\":\"did:velocity:0xd60231a3d0de0f197f1784f6f37ebcfaa291ab23#key-1\",\"alg\":\"ES256K\"}}"
    
    static let PresentationRequestJwt = VCLJWT(
        header: PresentationRequestJwtDecodedJson.toDictionary()?[VCLJWT.CodingKeys.KeyHeader] as? [String : Any],
        payload: PresentationRequestJwtDecodedJson.toDictionary()?[VCLJWT.CodingKeys.KeyPayload] as? [String : Any],
        signature: PresentationRequestJwtDecodedJson.toDictionary()?[VCLJWT.CodingKeys.KeySignature] as? String,
        encodedJwt: EncodedPresentationRequest
    )
    
    static let JWK = "{\"alg\":\"ES256K\",\"use\":\"sig\",\"kid\":\"uemn6l5ro6hLNrgiPRl1Dy51V9whez4tu4hlwsNOTVk\",\"crv\":\"secp256k1\",\"x\":\"oLYCa-AlnVpW8Rq9iST_1eY_XoyvGRry7y1xS4vU4qo\",\"y\":\"PUMAsawZ24WaSnRIdDb_wNbShAvfsGF71ke1DcJGxlM\",\"kty\":\"EC\"}\n"

    
    static let publicKey = VCLPublicKey(jwkStr: JWK)
    
    static let PresentationRequest = VCLPresentationRequest(
        jwt: PresentationRequestJwt,
        publicKey: publicKey,
        deepLink: DeepLinkMocks.PresentationRequestDeepLink
    )
}
