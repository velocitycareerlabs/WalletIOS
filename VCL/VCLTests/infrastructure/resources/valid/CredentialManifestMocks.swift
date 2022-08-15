//
//  CredentialManifestMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/05/2021.
//

import Foundation
@testable import VCL

class CredentialManifestMocks {
    static let CredentialManifestEncodedJwt =
        "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6MHhkNGRmMjk3MjZkNTAwZjliODViYzZjN2YxYjNjMDIxZjE2MzA1NjkyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyJleGNoYW5nZV9pZCI6IjYwZjQ3ZTMwNDRkNWIwMDAwYTA2YjU0NCIsIm91dHB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiIob2Zmc2V0OiAwIiwic2NoZW1hIjpbeyJ1cmkiOiIob2Zmc2V0OiAwIn1dfSx7ImlkIjoiIGVsZW1lbnQ6IFwiUGFzdEVtcGxveW1lbnRQb3NpdGlvblwiKSIsInNjaGVtYSI6W3sidXJpIjoiIGVsZW1lbnQ6IFwiUGFzdEVtcGxveW1lbnRQb3NpdGlvblwiKSJ9XX0seyJpZCI6IihvZmZzZXQ6IDEiLCJzY2hlbWEiOlt7InVyaSI6IihvZmZzZXQ6IDEifV19LHsiaWQiOiIgZWxlbWVudDogXCJDdXJyZW50RW1wbG95bWVudFBvc2l0aW9uXCIpIiwic2NoZW1hIjpbeyJ1cmkiOiIgZWxlbWVudDogXCJDdXJyZW50RW1wbG95bWVudFBvc2l0aW9uXCIpIn1dfV0sImlzc3VlciI6eyJpZCI6ImRpZDp2ZWxvY2l0eToweGQ0ZGYyOTcyNmQ1MDBmOWI4NWJjNmM3ZjFiM2MwMjFmMTYzMDU2OTIifSwicHJlc2VudGF0aW9uX2RlZmluaXRpb24iOnsiaWQiOiI2MGY0N2UzMDQ0ZDViMDAwMGEwNmI1NDQuNjBlODBkZjkwZjliOGUwMDFjNjhmYzMzIiwicHVycG9zZSI6IkNyZWRlbnRpYWwgSXNzdWFuY2UiLCJmb3JtYXQiOnsiand0X3ZwIjp7ImFsZyI6WyJzZWNwMjU2azEiXX19LCJpbnB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJQaG9uZSIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9waG9uZS5zY2hlbWEuanNvbiJ9XX0seyJpZCI6IkVtYWlsIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL2VtYWlsLnNjaGVtYS5qc29uIn1dfSx7ImlkIjoiSWREb2N1bWVudCIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9pZC1kb2N1bWVudC52MS5zY2hlbWEuanNvbiJ9XX1dfSwiaXNzIjoiZGlkOnZlbG9jaXR5OjB4ZDRkZjI5NzI2ZDUwMGY5Yjg1YmM2YzdmMWIzYzAyMWYxNjMwNTY5MiIsImlhdCI6MTYyNjYzNTgyNCwiZXhwIjoxNjI3MjQwNjI0LCJuYmYiOjE2MjY2MzU4MjR9.P_CVH35Hok4zpSnmd7ew2Si-99MoRuFo9AxeUFaEJHcv_lqfEu3q5Ow4z2N6C4r1F-q8EJIQwpGeg9ZACL3t8g"
    
    static let CredentialManifestEncodedJwtResponse =
        "{\"issuing_request\":\"\(CredentialManifestEncodedJwt)\"}"
        
    static let JWK = JwtServiceMocks.JWK
    
    static let Header = "{\"typ\":\"JWT\",\"kid\":\"did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692#key-1\",\"alg\":\"ES256K\"}"

    static let Payload = "{\"exchange_id\":\"60f47e3044d5b0000a06b544\",\"output_descriptors\":[{\"id\":\"(offset: 0\",\"schema\":[{\"uri\":\"(offset: 0\"}]},{\"id\":\" element: \\\"PastEmploymentPosition\\\")\",\"schema\":[{\"uri\":\" element: \\\"PastEmploymentPosition\\\")\"}]},{\"id\":\"(offset: 1\",\"schema\":[{\"uri\":\"(offset: 1\"}]},{\"id\":\" element: \\\"CurrentEmploymentPosition\\\")\",\"schema\":[{\"uri\":\" element: \\\"CurrentEmploymentPosition\\\")\"}]}],\"issuer\":{\"id\":\"did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692\"},\"presentation_definition\":{\"id\":\"60f47e3044d5b0000a06b544.60e80df90f9b8e001c68fc33\",\"purpose\":\"Credential Issuance\",\"format\":{\"jwt_vp\":{\"alg\":[\"secp256k1\"]}},\"input_descriptors\":[{\"id\":\"Phone\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/phone.schema.json\"}]},{\"id\":\"Email\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/email.schema.json\"}]},{\"id\":\"IdDocument\",\"schema\":[{\"uri\":\"https://devservices.velocitycareerlabs.io/api/v0.6/schemas/id-document.v1.schema.json\"}]}]},\"iss\":\"did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692\",\"iat\":1626635824,\"exp\":1627240624,\"nbf\":1626635824}"
    
    static let Signature = "P_CVH35Hok4zpSnmd7ew2Si-99MoRuFo9AxeUFaEJHcv_lqfEu3q5Ow4z2N6C4r1F-q8EJIQwpGeg9ZACL3t8g"

}
