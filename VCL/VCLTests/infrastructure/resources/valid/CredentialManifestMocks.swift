//
//  CredentialManifestMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class CredentialManifestMocks {
    static let JwtCredentialManifest1 =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6aW9uOkVpQXBNTGRNYjROUGI4c2FlOS1oWEdIUDc5VzFnaXNBcFZTRTgwVVNQRWJ0SkEjZXhjaGFuZ2Uta2V5LTEifQ.eyJleGNoYW5nZV9pZCI6IjY0NWUzMTUzMDkyMzdjNzYwYWMwMjJiMSIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiVW5pdmVyc2l0eSBvZiBNYXNzYWNodXNldHRzIEFtaGVyc3QgaW9uIiwibG9nb191cmkiOiJodHRwczovL3VwbG9hZC53aWtpbWVkaWEub3JnL3dpa2lwZWRpYS9lbi90aHVtYi80LzRmL1VuaXZlcnNpdHlfb2ZfTWFzc2FjaHVzZXR0c19BbWhlcnN0X3NlYWwuc3ZnLzEyMDBweC1Vbml2ZXJzaXR5X29mX01hc3NhY2h1c2V0dHNfQW1oZXJzdF9zZWFsLnN2Zy5wbmciLCJ0b3NfdXJpIjoiaHR0cHM6Ly93d3cudmVsb2NpdHlleHBlcmllbmNlY2VudGVyLmNvbS90ZXJtcy1hbmQtY29uZGl0aW9ucy12bmYiLCJtYXhfcmV0ZW50aW9uX3BlcmlvZCI6IjZtIiwicHJvZ3Jlc3NfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQXBNTGRNYjROUGI4c2FlOS1oWEdIUDc5VzFnaXNBcFZTRTgwVVNQRWJ0SkEvZ2V0LWV4Y2hhbmdlLXByb2dyZXNzIiwic3VibWl0X3ByZXNlbnRhdGlvbl91cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlBcE1MZE1iNE5QYjhzYWU5LWhYR0hQNzlXMWdpc0FwVlNFODBVU1BFYnRKQS9pc3N1ZS9zdWJtaXQtaWRlbnRpZmljYXRpb24iLCJjaGVja19vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQXBNTGRNYjROUGI4c2FlOS1oWEdIUDc5VzFnaXNBcFZTRTgwVVNQRWJ0SkEvaXNzdWUvY3JlZGVudGlhbC1vZmZlcnMiLCJmaW5hbGl6ZV9vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQXBNTGRNYjROUGI4c2FlOS1oWEdIUDc5VzFnaXNBcFZTRTgwVVNQRWJ0SkEvaXNzdWUvZmluYWxpemUtb2ZmZXJzIn0sInByZXNlbnRhdGlvbl9kZWZpbml0aW9uIjp7ImlkIjoiNjQ1ZTMxNTMwOTIzN2M3NjBhYzAyMmIxLjYzODRhM2FkMTQ4YjE5OTE2ODdmNjdjOSIsInB1cnBvc2UiOiJDcmVkZW50aWFscyBvZmZlciIsIm5hbWUiOiJTaGFyZSB5b3VyIElkLCBFbWFpbCBhbmQgUGhvbmUgTnVtYmVyIHRvIGZhY2lsaXRhdGUgdGhlIHNlYXJjaCBmb3IgeW91ciBjYXJlZXIgY3JlZGVudGlhbHMiLCJmb3JtYXQiOnsiand0X3ZwIjp7ImFsZyI6WyJzZWNwMjU2azEiXX19LCJpbnB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJFbWFpbFYxLjAiLCJuYW1lIjoiRW1haWwiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2cmVnaXN0cmFyLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvZW1haWwtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfV0sInN1Ym1pc3Npb25fcmVxdWlyZW1lbnRzIjpbeyJydWxlIjoiYWxsIiwiZnJvbSI6IkEiLCJtaW4iOjF9XX0sIm91dHB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJFbXBsb3ltZW50UGFzdFYxLjEiLCJuYW1lIjoiUGFzdCBlbXBsb3ltZW50IHBvc2l0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnJlZ2lzdHJhci52ZWxvY2l0eW5ldHdvcmsuZm91bmRhdGlvbi9zY2hlbWFzL2VtcGxveW1lbnQtcGFzdC12MS4xLnNjaGVtYS5qc29uIn1dLCJkaXNwbGF5Ijp7InRpdGxlIjp7InBhdGgiOlsiJC5sZWdhbEVtcGxveWVyLm5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifSwiZmFsbGJhY2siOiItIn0sInN1YnRpdGxlIjp7InBhdGgiOlsiJC5yb2xlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn0sImZhbGxiYWNrIjoiLSJ9LCJzdW1tYXJ5X2RldGFpbCI6eyJwYXRoIjpbIiQuZW5kRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifSwiZmFsbGJhY2siOiItIn0sImRlc2NyaXB0aW9uIjp7InRleHQiOiJQYXN0IGVtcGxveW1lbnQgcG9zaXRpb24ifSwicHJvcGVydGllcyI6W3sibGFiZWwiOiJSb2xlIGRlc2NyaXB0aW9uIiwicGF0aCI6WyIkLmRlc2NyaXB0aW9uIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJTdGFydCBEYXRlIiwicGF0aCI6WyIkLnN0YXJ0RGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifX0seyJsYWJlbCI6IkVuZCBkYXRlIiwicGF0aCI6WyIkLmVuZERhdGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmciLCJmb3JtYXQiOiJkYXRlIn19LHsibGFiZWwiOiJQbGFjZSBvZiB3b3JrIiwicGF0aCI6WyIkLnBsYWNlLmFkZHJlc3NMb2NhbGl0eSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiU3RhdGUgb3IgcmVnaW9uIG9mIHdvcmsiLCJwYXRoIjpbIiQucGxhY2UuYWRkcmVzc1JlZ2lvbiJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiQ291bnRyeSBvZiB3b3JrIiwicGF0aCI6WyIkLnBsYWNlLmFkZHJlc3NDb3VudHJ5Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJFbXBsb3ltZW50IHR5cGUiLCJwYXRoIjpbIiQuZW1wbG95bWVudFR5cGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBnaXZlbiBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5naXZlbk5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBtaWRkbGUgbmFtZSIsInBhdGgiOlsiJC5yZWNpcGllbnQubWlkZGxlTmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IGZhbWlseSBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5mYW1pbHlOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJSZWNpcGllbnQgbmFtZSBwcmVmaXgiLCJwYXRoIjpbIiQucmVjaXBpZW50Lm5hbWVQcmVmaXgiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBuYW1lIHN1ZmZpeCIsInBhdGgiOlsiJC5yZWNpcGllbnQubmFtZVN1ZmZpeCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiQWxpZ25tZW50IiwicGF0aCI6WyIkLmFsaWdubWVudFswXS50YXJnZXROYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJBbGlnbm1lbnQgVVJMIiwicGF0aCI6WyIkLmFsaWdubWVudFswXS50YXJnZXRVcmwiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmciLCJmb3JtYXQiOiJ1cmkifX0seyJsYWJlbCI6IkFsaWdubWVudCBmcmFtZXdvcmsiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldEZyYW1ld29yayJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fV19fV0sImlzc3VlciI6eyJpZCI6ImRpZDppb246RWlBcE1MZE1iNE5QYjhzYWU5LWhYR0hQNzlXMWdpc0FwVlNFODBVU1BFYnRKQSJ9LCJuYmYiOjE2ODM4OTQ2MTEsImlzcyI6ImRpZDppb246RWlBcE1MZE1iNE5QYjhzYWU5LWhYR0hQNzlXMWdpc0FwVlNFODBVU1BFYnRKQSIsImV4cCI6MTY4NDQ5OTQxMSwiaWF0IjoxNjgzODk0NjExfQ.0G3dOayFASSv4GGjVzaF-fJSmAh-egictK_R4NGcLRJzSeF8CysO_Lyxobhu87ye9U8_GursgOuJKrx7FkGPcw"
    
    static let JwtCredentialManifest2 =
    "eyJ0eXAiOiJKV1QiLCJraWQiOiJkaWQ6dmVsb2NpdHk6MHhkNGRmMjk3MjZkNTAwZjliODViYzZjN2YxYjNjMDIxZjE2MzA1NjkyI2tleS0xIiwiYWxnIjoiRVMyNTZLIn0.eyAiZXhjaGFuZ2VfaWQiOiAiNjBmNDdlMzA0NGQ1YjAwMDBhMDZiNTQ0IiwgIm91dHB1dF9kZXNjcmlwdG9ycyI6IFsgeyAiaWQiOiAiKG9mZnNldDogMCIsICJzY2hlbWEiOiBbIHsgInVyaSI6ICIob2Zmc2V0OiAwIiB9IF0gfSwgeyAiaWQiOiAiIGVsZW1lbnQ6IFwiUGFzdEVtcGxveW1lbnRQb3NpdGlvblwiKSIsICJzY2hlbWEiOiBbIHsgInVyaSI6ICIgZWxlbWVudDogXCJQYXN0RW1wbG95bWVudFBvc2l0aW9uXCIpIiB9IF0gfSwgeyAiaWQiOiAiKG9mZnNldDogMSIsICJzY2hlbWEiOiBbIHsgInVyaSI6ICIob2Zmc2V0OiAxIiB9IF0gfSwgeyAiaWQiOiAiIGVsZW1lbnQ6IFwiQ3VycmVudEVtcGxveW1lbnRQb3NpdGlvblwiKSIsICJzY2hlbWEiOiBbIHsgInVyaSI6ICIgZWxlbWVudDogXCJDdXJyZW50RW1wbG95bWVudFBvc2l0aW9uXCIpIiB9IF0gfSBdLCAiaXNzdWVyIjogeyAiaWQiOiAiZGlkOnZlbG9jaXR5OjB4YmE3ZDg3ZjlkNWU0NzNkN2QzYTgyZDE1MjkyM2FkYjUzZGU4ZmMwZSIgfSwgInByZXNlbnRhdGlvbl9kZWZpbml0aW9uIjogeyAiaWQiOiAiNjBmNDdlMzA0NGQ1YjAwMDBhMDZiNTQ0LjYwZTgwZGY5MGY5YjhlMDAxYzY4ZmMzMyIsICJwdXJwb3NlIjogIkNyZWRlbnRpYWwgSXNzdWFuY2UiLCAiZm9ybWF0IjogeyAiand0X3ZwIjogeyAiYWxnIjogWyAic2VjcDI1NmsxIiBdIH0gfSwgImlucHV0X2Rlc2NyaXB0b3JzIjogWyB7ICJpZCI6ICJQaG9uZSIsICJzY2hlbWEiOiBbIHsgInVyaSI6ICJodHRwczovL2RldnNlcnZpY2VzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvdjAuNi9zY2hlbWFzL3Bob25lLnNjaGVtYS5qc29uIiB9IF0gfSwgeyAiaWQiOiAiRW1haWwiLCAic2NoZW1hIjogWyB7ICJ1cmkiOiAiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9lbWFpbC5zY2hlbWEuanNvbiIgfSBdIH0sIHsgImlkIjogIklkRG9jdW1lbnQiLCAic2NoZW1hIjogWyB7ICJ1cmkiOiAiaHR0cHM6Ly9kZXZzZXJ2aWNlcy52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL3YwLjYvc2NoZW1hcy9pZC1kb2N1bWVudC52MS5zY2hlbWEuanNvbiIgfSBdIH0gXSB9LCAiaXNzIjogImRpZDp2ZWxvY2l0eToweGJhN2Q4N2Y5ZDVlNDczZDdkM2E4MmQxNTI5MjNhZGI1M2RlOGZjMGUiLCAiaWF0IjogMTYyNjYzNTgyNCwgImV4cCI6IDE2MjcyNDA2MjQsICJuYmYiOiAxNjI2NjM1ODI0IH0=.P_CVH35Hok4zpSnmd7ew2Si-99MoRuFo9AxeUFaEJHcv_lqfEu3q5Ow4z2N6C4r1F-q8EJIQwpGeg9ZACL3t8g"
    
    static let CredentialManifest1 =
    "{\"issuing_request\":\"\(JwtCredentialManifest1)\"}"
    
    static let CredentialManifest2 =
    "{\"issuing_request\":\"\(JwtCredentialManifest2)\"}"
    
    static let JWK =
    "{\"crv\":\"secp256k1\",\"use\":\"sig\",\"x\":\"NZjgOKm-tbZgX_79SGnud7oGQ8MZc-lP79WCm68W9jE\",\"y\":\"3bc68UxPKMsZ7DtwVaajsbiIXaCGcaaeItIXOlNMI4U\",\"kty\":\"EC\"}"
    
    static let Header =
    "{ \"typ\": \"JWT\", \"alg\": \"ES256K\", \"kid\": \"did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA#exchange-key-1\" }".toDictionary()!
    
    static let Payload =
    "{ \"exchange_id\": \"645e315309237c760ac022b1\", \"metadata\": { \"client_name\": \"University of Massachusetts Amherst ion\", \"logo_uri\": \"https://upload.wikimedia.org/wikipedia/en/thumb/4/4f/University_of_Massachusetts_Amherst_seal.svg/1200px-University_of_Massachusetts_Amherst_seal.svg.png\", \"tos_uri\": \"https://www.velocityexperiencecenter.com/terms-and-conditions-vnf\", \"max_retention_period\": \"6m\", \"progress_uri\": \"https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/get-exchange-progress\", \"submit_presentation_uri\": \"https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/submit-identification\", \"check_offers_uri\": \"https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/credential-offers\", \"finalize_offers_uri\": \"https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/finalize-offers\" }, \"presentation_definition\": { \"id\": \"645e315309237c760ac022b1.6384a3ad148b1991687f67c9\", \"purpose\": \"Credentials offer\", \"name\": \"Share your Id, Email and Phone Number to facilitate the search for your career credentials\", \"format\": { \"jwt_vp\": { \"alg\": [ \"secp256k1\" ] } }, \"input_descriptors\": [ { \"id\": \"EmailV1.0\", \"name\": \"Email\", \"schema\": [ { \"uri\": \"https://devregistrar.velocitynetwork.foundation/schemas/email-v1.0.schema.json\" } ], \"group\": [ \"A\" ] } ], \"submission_requirements\": [ { \"rule\": \"all\", \"from\": \"A\", \"min\": 1 } ] }, \"output_descriptors\": [ { \"id\": \"EmploymentPastV1.1\", \"name\": \"Past employment position\", \"schema\": [ { \"uri\": \"https://devregistrar.velocitynetwork.foundation/schemas/employment-past-v1.1.schema.json\" } ], \"display\": { \"title\": { \"path\": [ \".legalEmployer.name\" ], \"schema\": { \"type\": \"string\" }, \"fallback\": \"-\" }, \"subtitle\": { \"path\": [ \".role\" ], \"schema\": { \"type\": \"string\" }, \"fallback\": \"-\" }, \"summary_detail\": { \"path\": [ \".endDate\" ], \"schema\": { \"type\": \"string\", \"format\": \"date\" }, \"fallback\": \"-\" }, \"description\": { \"text\": \"Past employment position\" }, \"properties\": [ { \"label\": \"Role description\", \"path\": [ \".description\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Start Date\", \"path\": [ \".startDate\" ], \"schema\": { \"type\": \"string\", \"format\": \"date\" } }, { \"label\": \"End date\", \"path\": [ \".endDate\" ], \"schema\": { \"type\": \"string\", \"format\": \"date\" } }, { \"label\": \"Place of work\", \"path\": [ \".place.addressLocality\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"State or region of work\", \"path\": [ \".place.addressRegion\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Country of work\", \"path\": [ \".place.addressCountry\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Employment type\", \"path\": [ \".employmentType\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Recipient given name\", \"path\": [ \".recipient.givenName\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Recipient middle name\", \"path\": [ \".recipient.middleName\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Recipient family name\", \"path\": [ \".recipient.familyName\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Recipient name prefix\", \"path\": [ \".recipient.namePrefix\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Recipient name suffix\", \"path\": [ \".recipient.nameSuffix\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Alignment\", \"path\": [ \".alignment[0].targetName\" ], \"schema\": { \"type\": \"string\" } }, { \"label\": \"Alignment URL\", \"path\": [ \".alignment[0].targetUrl\" ], \"schema\": { \"type\": \"string\", \"format\": \"uri\" } }, { \"label\": \"Alignment framework\", \"path\": [ \".alignment[0].targetFramework\" ], \"schema\": { \"type\": \"string\" } } ] } } ], \"issuer\": { \"id\": \"did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA\" }, \"nbf\": 1683894611, \"iss\": \"did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA\", \"exp\": 1684499411, \"iat\": 1683894611 }".toDictionary()!
    
    static let Signature =
    "0G3dOayFASSv4GGjVzaF-fJSmAh-egictK_R4NGcLRJzSeF8CysO_Lyxobhu87ye9U8_GursgOuJKrx7FkGPcw"
    
    static let JwtCredentialManifestFromRegularIssuer =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6aW9uOkVpQk1zdzI3SUtSWUlkd1VPZkRlQmQwTG5XVmVHMmZQeHhKaTlMMWZ2ak0yMGcjZXhjaGFuZ2Uta2V5LTEifQ.eyJleGNoYW5nZV9pZCI6IjY0YWYxMDRhZjllZGFiMGVhOTE5ZjUwOCIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiUmVndWxhciBJc3N1aWVyIChOT1QgTm90YXR5L0lkZW50aXR5KSIsImxvZ29fdXJpIjoiaHR0cDovL3Rlc3RpbmctY29tcGFuaWVzLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxNi8wNi9idy1xYS5wbmciLCJ0b3NfdXJpIjoiaHR0cHM6Ly93d3cudmVsb2NpdHlleHBlcmllbmNlY2VudGVyLmNvbS90ZXJtcy1hbmQtY29uZGl0aW9ucy12bmYiLCJtYXhfcmV0ZW50aW9uX3BlcmlvZCI6IjZtIiwicHJvZ3Jlc3NfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQk1zdzI3SUtSWUlkd1VPZkRlQmQwTG5XVmVHMmZQeHhKaTlMMWZ2ak0yMGcvZ2V0LWV4Y2hhbmdlLXByb2dyZXNzIiwic3VibWl0X3ByZXNlbnRhdGlvbl91cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlCTXN3MjdJS1JZSWR3VU9mRGVCZDBMbldWZUcyZlB4eEppOUwxZnZqTTIwZy9pc3N1ZS9zdWJtaXQtaWRlbnRpZmljYXRpb24iLCJjaGVja19vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQk1zdzI3SUtSWUlkd1VPZkRlQmQwTG5XVmVHMmZQeHhKaTlMMWZ2ak0yMGcvaXNzdWUvY3JlZGVudGlhbC1vZmZlcnMiLCJmaW5hbGl6ZV9vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQk1zdzI3SUtSWUlkd1VPZkRlQmQwTG5XVmVHMmZQeHhKaTlMMWZ2ak0yMGcvaXNzdWUvZmluYWxpemUtb2ZmZXJzIn0sInByZXNlbnRhdGlvbl9kZWZpbml0aW9uIjp7ImlkIjoiNjRhZjEwNGFmOWVkYWIwZWE5MTlmNTA4LjY0YWViMTIzYzc4ZWQ0YzMzODJkMmQwZSIsInB1cnBvc2UiOiJDcmVkZW50aWFscyBvZmZlciIsIm5hbWUiOiJJc3N1aW5nIERpc2Nsb3N1cmUiLCJmb3JtYXQiOnsiand0X3ZwIjp7ImFsZyI6WyJzZWNwMjU2azEiXX19LCJpbnB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJFbWFpbFYxLjAiLCJuYW1lIjoiRW1haWwiLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2cmVnaXN0cmFyLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvZW1haWwtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfV0sInN1Ym1pc3Npb25fcmVxdWlyZW1lbnRzIjpbeyJydWxlIjoiYWxsIiwiZnJvbSI6IkEiLCJtaW4iOjF9XX0sIm91dHB1dF9kZXNjcmlwdG9ycyI6W3siaWQiOiJFZHVjYXRpb25EZWdyZWVSZWdpc3RyYXRpb25WMS4xIiwibmFtZSI6IkVkdWNhdGlvbiBkZWdyZWUgcmVnaXN0cmF0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnJlZ2lzdHJhci52ZWxvY2l0eW5ldHdvcmsuZm91bmRhdGlvbi9zY2hlbWFzL2VkdWNhdGlvbi1kZWdyZWUtcmVnaXN0cmF0aW9uLXYxLjEuc2NoZW1hLmpzb24ifV0sImRpc3BsYXkiOnsidGl0bGUiOnsicGF0aCI6WyIkLmluc3RpdHV0aW9uLm5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifSwiZmFsbGJhY2siOiItIn0sInN1YnRpdGxlIjp7InBhdGgiOlsiJC5kZWdyZWVOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn0sImZhbGxiYWNrIjoiLSJ9LCJzdW1tYXJ5X2RldGFpbCI6eyJwYXRoIjpbIiQucmVnaXN0cmF0aW9uRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifSwiZmFsbGJhY2siOiItIn0sImRlc2NyaXB0aW9uIjp7InRleHQiOiJEZWdyZWUgcmVnaXN0cmF0aW9uIn0sImxvZ28iOnsicGF0aCI6WyIkLmluc3RpdHV0aW9uLmltYWdlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoidXJpIn19LCJwcm9wZXJ0aWVzIjpbeyJsYWJlbCI6IlNjaG9vbCBvciBkZXBhcnRtZW50IiwicGF0aCI6WyIkLnNjaG9vbC5uYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJEZXNjcmlwdGlvbiIsInBhdGgiOlsiJC5kZXNjcmlwdGlvbiJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVnaXN0cmF0aW9uIERhdGUiLCJwYXRoIjpbIiQucmVnaXN0cmF0aW9uRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifX0seyJsYWJlbCI6IlN0YXJ0IERhdGUiLCJwYXRoIjpbIiQuc3RhcnREYXRlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoiZGF0ZSJ9fSx7ImxhYmVsIjoiTWFqb3IiLCJwYXRoIjpbIiQuZGVncmVlTWFqb3JbKl0iXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6Ik1pbm9yIiwicGF0aCI6WyIkLmRlZ3JlZU1pbm9yWypdIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJQcm9ncmFtIiwicGF0aCI6WyIkLnByb2dyYW1OYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJQcm9ncmFtIHR5cGUiLCJwYXRoIjpbIiQucHJvZ3JhbVR5cGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlByb2dyYW0gbW9kZSIsInBhdGgiOlsiJC5wcm9ncmFtTW9kZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IGdpdmVuIG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmdpdmVuTmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG1pZGRsZSBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5taWRkbGVOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJSZWNpcGllbnQgZmFtaWx5IG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmZhbWlseU5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBuYW1lIHByZWZpeCIsInBhdGgiOlsiJC5yZWNpcGllbnQubmFtZVByZWZpeCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG5hbWUgc3VmZml4IiwicGF0aCI6WyIkLnJlY2lwaWVudC5uYW1lU3VmZml4Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJBbGlnbm1lbnQiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldE5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IkFsaWdubWVudCBVUkwiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldFVybCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6InVyaSJ9fSx7ImxhYmVsIjoiQWxpZ25tZW50IGZyYW1ld29yayIsInBhdGgiOlsiJC5hbGlnbm1lbnRbMF0udGFyZ2V0RnJhbWV3b3JrIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19XX19LHsiaWQiOiJFbXBsb3ltZW50UGFzdFYxLjEiLCJuYW1lIjoiUGFzdCBlbXBsb3ltZW50IHBvc2l0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnJlZ2lzdHJhci52ZWxvY2l0eW5ldHdvcmsuZm91bmRhdGlvbi9zY2hlbWFzL2VtcGxveW1lbnQtcGFzdC12MS4xLnNjaGVtYS5qc29uIn1dLCJkaXNwbGF5Ijp7InRpdGxlIjp7InBhdGgiOlsiJC5sZWdhbEVtcGxveWVyLm5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifSwiZmFsbGJhY2siOiItIn0sInN1YnRpdGxlIjp7InBhdGgiOlsiJC5yb2xlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn0sImZhbGxiYWNrIjoiLSJ9LCJzdW1tYXJ5X2RldGFpbCI6eyJwYXRoIjpbIiQuZW5kRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifSwiZmFsbGJhY2siOiItIn0sImRlc2NyaXB0aW9uIjp7InRleHQiOiJQYXN0IGVtcGxveW1lbnQgcG9zaXRpb24ifSwibG9nbyI6eyJwYXRoIjpbIiQubGVnYWxFbXBsb3llci5pbWFnZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6InVyaSJ9fSwicHJvcGVydGllcyI6W3sibGFiZWwiOiJSb2xlIGRlc2NyaXB0aW9uIiwicGF0aCI6WyIkLmRlc2NyaXB0aW9uIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJTdGFydCBEYXRlIiwicGF0aCI6WyIkLnN0YXJ0RGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifX0seyJsYWJlbCI6IkVuZCBkYXRlIiwicGF0aCI6WyIkLmVuZERhdGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmciLCJmb3JtYXQiOiJkYXRlIn19LHsibGFiZWwiOiJQbGFjZSBvZiB3b3JrIiwicGF0aCI6WyIkLnBsYWNlLmFkZHJlc3NMb2NhbGl0eSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiU3RhdGUgb3IgcmVnaW9uIG9mIHdvcmsiLCJwYXRoIjpbIiQucGxhY2UuYWRkcmVzc1JlZ2lvbiJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiQ291bnRyeSBvZiB3b3JrIiwicGF0aCI6WyIkLnBsYWNlLmFkZHJlc3NDb3VudHJ5Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJFbXBsb3ltZW50IHR5cGUiLCJwYXRoIjpbIiQuZW1wbG95bWVudFR5cGVbKl0iXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBnaXZlbiBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5naXZlbk5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBtaWRkbGUgbmFtZSIsInBhdGgiOlsiJC5yZWNpcGllbnQubWlkZGxlTmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IGZhbWlseSBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5mYW1pbHlOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJSZWNpcGllbnQgbmFtZSBwcmVmaXgiLCJwYXRoIjpbIiQucmVjaXBpZW50Lm5hbWVQcmVmaXgiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBuYW1lIHN1ZmZpeCIsInBhdGgiOlsiJC5yZWNpcGllbnQubmFtZVN1ZmZpeCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiQWxpZ25tZW50IiwicGF0aCI6WyIkLmFsaWdubWVudFswXS50YXJnZXROYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJBbGlnbm1lbnQgVVJMIiwicGF0aCI6WyIkLmFsaWdubWVudFswXS50YXJnZXRVcmwiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmciLCJmb3JtYXQiOiJ1cmkifX0seyJsYWJlbCI6IkFsaWdubWVudCBmcmFtZXdvcmsiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldEZyYW1ld29yayJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fV19fV0sImlzc3VlciI6eyJpZCI6ImRpZDppb246RWlCTXN3MjdJS1JZSWR3VU9mRGVCZDBMbldWZUcyZlB4eEppOUwxZnZqTTIwZyJ9LCJuYmYiOjE2ODkxOTQ4NTgsImlzcyI6ImRpZDppb246RWlCTXN3MjdJS1JZSWR3VU9mRGVCZDBMbldWZUcyZlB4eEppOUwxZnZqTTIwZyIsImV4cCI6MTY4OTc5OTY1OCwiaWF0IjoxNjg5MTk0ODU4fQ.93MlXcv8aR3niARSnLqQRCZuR_-s-bwVxyCfqKULGfK-9o2csW1jgg37FPVJKYNiqyqpgOxUf8KcbHqoN6CEIA"
    
    static let JwtCredentialManifestFromNotaryIssuer =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6aW9uOkVpQ1ZEVERRV25YTTcxekJvazdTTWozZ0I5SkozdXRXTkJlY2pXcEQycDdPU0EjZXhjaGFuZ2Uta2V5LTEifQ.eyJleGNoYW5nZV9pZCI6IjY0YWYxNDVmYWQ3NDBhMGI2ODVhMmE1NiIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiTm90YXJ5IElzc3VlciIsImxvZ29fdXJpIjoiaHR0cHM6Ly9kb2NzLnZlbG9jaXR5Y2FyZWVybGFicy5pby9Mb2dvcy9DQS1ib2FyZC5wbmciLCJ0b3NfdXJpIjoiaHR0cHM6Ly93d3cudmVsb2NpdHlleHBlcmllbmNlY2VudGVyLmNvbS90ZXJtcy1hbmQtY29uZGl0aW9ucy12bmYiLCJtYXhfcmV0ZW50aW9uX3BlcmlvZCI6IjZtIiwicHJvZ3Jlc3NfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQ1ZEVERRV25YTTcxekJvazdTTWozZ0I5SkozdXRXTkJlY2pXcEQycDdPU0EvZ2V0LWV4Y2hhbmdlLXByb2dyZXNzIiwic3VibWl0X3ByZXNlbnRhdGlvbl91cmkiOiJodHRwczovL2RldmFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlDVkRURFFXblhNNzF6Qm9rN1NNajNnQjlKSjN1dFdOQmVjaldwRDJwN09TQS9pc3N1ZS9zdWJtaXQtaWRlbnRpZmljYXRpb24iLCJjaGVja19vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQ1ZEVERRV25YTTcxekJvazdTTWozZ0I5SkozdXRXTkJlY2pXcEQycDdPU0EvaXNzdWUvY3JlZGVudGlhbC1vZmZlcnMiLCJmaW5hbGl6ZV9vZmZlcnNfdXJpIjoiaHR0cHM6Ly9kZXZhZ2VudC52ZWxvY2l0eWNhcmVlcmxhYnMuaW8vYXBpL2hvbGRlci92MC42L29yZy9kaWQ6aW9uOkVpQ1ZEVERRV25YTTcxekJvazdTTWozZ0I5SkozdXRXTkJlY2pXcEQycDdPU0EvaXNzdWUvZmluYWxpemUtb2ZmZXJzIn0sInByZXNlbnRhdGlvbl9kZWZpbml0aW9uIjp7ImlkIjoiNjRhZjE0NWZhZDc0MGEwYjY4NWEyYTU2LjY0NWNjOGM3MGY3NmFlOGM2ZTI3OTlkNyIsInB1cnBvc2UiOiJJc3N1aW5nIHRlc3QiLCJuYW1lIjoiRGlzbG9zdXJlLCB0aGF0IHJlcXVlc3RzIGFsbCBjcmVkZW50aWFscyB0eXBlcywgZm9yIHRlc3RpbmcgY29tbW9uIEluc3BlY3Rpb24gZmxvdyIsImZvcm1hdCI6eyJqd3RfdnAiOnsiYWxnIjpbInNlY3AyNTZrMSJdfX0sImlucHV0X2Rlc2NyaXB0b3JzIjpbeyJpZCI6IkVtYWlsVjEuMCIsIm5hbWUiOiJFbWFpbCIsInNjaGVtYSI6W3sidXJpIjoiaHR0cHM6Ly9kZXZyZWdpc3RyYXIudmVsb2NpdHluZXR3b3JrLmZvdW5kYXRpb24vc2NoZW1hcy9lbWFpbC12MS4wLnNjaGVtYS5qc29uIn1dLCJncm91cCI6WyJBIl19XSwic3VibWlzc2lvbl9yZXF1aXJlbWVudHMiOlt7InJ1bGUiOiJhbGwiLCJmcm9tIjoiQSIsIm1pbiI6MX1dfSwib3V0cHV0X2Rlc2NyaXB0b3JzIjpbeyJpZCI6IkVtcGxveW1lbnRQYXN0VjEuMSIsIm5hbWUiOiJQYXN0IGVtcGxveW1lbnQgcG9zaXRpb24iLCJzY2hlbWEiOlt7InVyaSI6Imh0dHBzOi8vZGV2cmVnaXN0cmFyLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvZW1wbG95bWVudC1wYXN0LXYxLjEuc2NoZW1hLmpzb24ifV0sImRpc3BsYXkiOnsidGl0bGUiOnsicGF0aCI6WyIkLmxlZ2FsRW1wbG95ZXIubmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9LCJmYWxsYmFjayI6Ii0ifSwic3VidGl0bGUiOnsicGF0aCI6WyIkLnJvbGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifSwiZmFsbGJhY2siOiItIn0sInN1bW1hcnlfZGV0YWlsIjp7InBhdGgiOlsiJC5lbmREYXRlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoiZGF0ZSJ9LCJmYWxsYmFjayI6Ii0ifSwiZGVzY3JpcHRpb24iOnsidGV4dCI6IlBhc3QgZW1wbG95bWVudCBwb3NpdGlvbiJ9LCJsb2dvIjp7InBhdGgiOlsiJC5sZWdhbEVtcGxveWVyLmltYWdlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoidXJpIn19LCJwcm9wZXJ0aWVzIjpbeyJsYWJlbCI6IlJvbGUgZGVzY3JpcHRpb24iLCJwYXRoIjpbIiQuZGVzY3JpcHRpb24iXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlN0YXJ0IERhdGUiLCJwYXRoIjpbIiQuc3RhcnREYXRlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoiZGF0ZSJ9fSx7ImxhYmVsIjoiRW5kIGRhdGUiLCJwYXRoIjpbIiQuZW5kRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifX0seyJsYWJlbCI6IlBsYWNlIG9mIHdvcmsiLCJwYXRoIjpbIiQucGxhY2UuYWRkcmVzc0xvY2FsaXR5Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJTdGF0ZSBvciByZWdpb24gb2Ygd29yayIsInBhdGgiOlsiJC5wbGFjZS5hZGRyZXNzUmVnaW9uIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJDb3VudHJ5IG9mIHdvcmsiLCJwYXRoIjpbIiQucGxhY2UuYWRkcmVzc0NvdW50cnkiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IkVtcGxveW1lbnQgdHlwZSIsInBhdGgiOlsiJC5lbXBsb3ltZW50VHlwZVsqXSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IGdpdmVuIG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmdpdmVuTmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG1pZGRsZSBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5taWRkbGVOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJSZWNpcGllbnQgZmFtaWx5IG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmZhbWlseU5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBuYW1lIHByZWZpeCIsInBhdGgiOlsiJC5yZWNpcGllbnQubmFtZVByZWZpeCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG5hbWUgc3VmZml4IiwicGF0aCI6WyIkLnJlY2lwaWVudC5uYW1lU3VmZml4Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJBbGlnbm1lbnQiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldE5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IkFsaWdubWVudCBVUkwiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldFVybCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6InVyaSJ9fSx7ImxhYmVsIjoiQWxpZ25tZW50IGZyYW1ld29yayIsInBhdGgiOlsiJC5hbGlnbm1lbnRbMF0udGFyZ2V0RnJhbWV3b3JrIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19XX19LHsiaWQiOiJFZHVjYXRpb25EZWdyZWVSZWdpc3RyYXRpb25WMS4xIiwibmFtZSI6IkVkdWNhdGlvbiBkZWdyZWUgcmVnaXN0cmF0aW9uIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL2RldnJlZ2lzdHJhci52ZWxvY2l0eW5ldHdvcmsuZm91bmRhdGlvbi9zY2hlbWFzL2VkdWNhdGlvbi1kZWdyZWUtcmVnaXN0cmF0aW9uLXYxLjEuc2NoZW1hLmpzb24ifV0sImRpc3BsYXkiOnsidGl0bGUiOnsicGF0aCI6WyIkLmluc3RpdHV0aW9uLm5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifSwiZmFsbGJhY2siOiItIn0sInN1YnRpdGxlIjp7InBhdGgiOlsiJC5kZWdyZWVOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn0sImZhbGxiYWNrIjoiLSJ9LCJzdW1tYXJ5X2RldGFpbCI6eyJwYXRoIjpbIiQucmVnaXN0cmF0aW9uRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifSwiZmFsbGJhY2siOiItIn0sImRlc2NyaXB0aW9uIjp7InRleHQiOiJEZWdyZWUgcmVnaXN0cmF0aW9uIn0sImxvZ28iOnsicGF0aCI6WyIkLmluc3RpdHV0aW9uLmltYWdlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoidXJpIn19LCJwcm9wZXJ0aWVzIjpbeyJsYWJlbCI6IlNjaG9vbCBvciBkZXBhcnRtZW50IiwicGF0aCI6WyIkLnNjaG9vbC5uYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJEZXNjcmlwdGlvbiIsInBhdGgiOlsiJC5kZXNjcmlwdGlvbiJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVnaXN0cmF0aW9uIERhdGUiLCJwYXRoIjpbIiQucmVnaXN0cmF0aW9uRGF0ZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6ImRhdGUifX0seyJsYWJlbCI6IlN0YXJ0IERhdGUiLCJwYXRoIjpbIiQuc3RhcnREYXRlIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIiwiZm9ybWF0IjoiZGF0ZSJ9fSx7ImxhYmVsIjoiTWFqb3IiLCJwYXRoIjpbIiQuZGVncmVlTWFqb3JbKl0iXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6Ik1pbm9yIiwicGF0aCI6WyIkLmRlZ3JlZU1pbm9yWypdIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJQcm9ncmFtIiwicGF0aCI6WyIkLnByb2dyYW1OYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJQcm9ncmFtIHR5cGUiLCJwYXRoIjpbIiQucHJvZ3JhbVR5cGUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlByb2dyYW0gbW9kZSIsInBhdGgiOlsiJC5wcm9ncmFtTW9kZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IGdpdmVuIG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmdpdmVuTmFtZSJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG1pZGRsZSBuYW1lIiwicGF0aCI6WyIkLnJlY2lwaWVudC5taWRkbGVOYW1lIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJSZWNpcGllbnQgZmFtaWx5IG5hbWUiLCJwYXRoIjpbIiQucmVjaXBpZW50LmZhbWlseU5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IlJlY2lwaWVudCBuYW1lIHByZWZpeCIsInBhdGgiOlsiJC5yZWNpcGllbnQubmFtZVByZWZpeCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyJ9fSx7ImxhYmVsIjoiUmVjaXBpZW50IG5hbWUgc3VmZml4IiwicGF0aCI6WyIkLnJlY2lwaWVudC5uYW1lU3VmZml4Il0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19LHsibGFiZWwiOiJBbGlnbm1lbnQiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldE5hbWUiXSwic2NoZW1hIjp7InR5cGUiOiJzdHJpbmcifX0seyJsYWJlbCI6IkFsaWdubWVudCBVUkwiLCJwYXRoIjpbIiQuYWxpZ25tZW50WzBdLnRhcmdldFVybCJdLCJzY2hlbWEiOnsidHlwZSI6InN0cmluZyIsImZvcm1hdCI6InVyaSJ9fSx7ImxhYmVsIjoiQWxpZ25tZW50IGZyYW1ld29yayIsInBhdGgiOlsiJC5hbGlnbm1lbnRbMF0udGFyZ2V0RnJhbWV3b3JrIl0sInNjaGVtYSI6eyJ0eXBlIjoic3RyaW5nIn19XX19XSwiaXNzdWVyIjp7ImlkIjoiZGlkOmlvbjpFaUNWRFREUVduWE03MXpCb2s3U01qM2dCOUpKM3V0V05CZWNqV3BEMnA3T1NBIn0sIm5iZiI6MTY4OTE5NTczMywiaXNzIjoiZGlkOmlvbjpFaUNWRFREUVduWE03MXpCb2s3U01qM2dCOUpKM3V0V05CZWNqV3BEMnA3T1NBIiwiZXhwIjoxNjg5ODAwNTMzLCJpYXQiOjE2ODkxOTU3MzN9.ZZsMAICah6vy5n4CVjuEry80SeRA-tS4_3EhHTfHzOAcp0-KRMTNCyWgEN6475CgwZLP_85y84Sv2qGs6qRZug"
    
    static let JwtCredentialManifestForValidCredentialMicrsoftQa =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6aW9uOkVpRDFxcjBaSmZUdURqZHJWZ0FRVHhsWVVHemwzeWltbEYxWVAtY29yNnpkc2cjZXhjaGFuZ2Uta2V5LTEifQ.eyJleGNoYW5nZV9pZCI6IjY1ZDVmNzc1ZjBkNmUxMzg4ODJlZWJjZSIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiTWljcm9zb2Z0IENvcnBvcmF0aW9uIiwibG9nb191cmkiOiJodHRwczovL2Fnc29sLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxOC8wOS9uZXctbWljcm9zb2Z0LWxvZ28tU0laRUQtU1FVQVJFLmpwZyIsInRvc191cmkiOiJodHRwczovL3d3dy52ZWxvY2l0eWV4cGVyaWVuY2VjZW50ZXIuY29tL3Rlcm1zLWFuZC1jb25kaXRpb25zLXZuZiIsIm1heF9yZXRlbnRpb25fcGVyaW9kIjoiNm0iLCJwcm9ncmVzc191cmkiOiJodHRwczovL3FhYWdlbnQudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS9ob2xkZXIvdjAuNi9vcmcvZGlkOmlvbjpFaUQxcXIwWkpmVHVEamRyVmdBUVR4bFlVR3psM3lpbWxGMVlQLWNvcjZ6ZHNnL2dldC1leGNoYW5nZS1wcm9ncmVzcyIsInN1Ym1pdF9wcmVzZW50YXRpb25fdXJpIjoiaHR0cHM6Ly9xYWFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZy9pc3N1ZS9zdWJtaXQtaWRlbnRpZmljYXRpb24iLCJjaGVja19vZmZlcnNfdXJpIjoiaHR0cHM6Ly9xYWFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZy9pc3N1ZS9jcmVkZW50aWFsLW9mZmVycyIsImZpbmFsaXplX29mZmVyc191cmkiOiJodHRwczovL3FhYWdlbnQudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS9ob2xkZXIvdjAuNi9vcmcvZGlkOmlvbjpFaUQxcXIwWkpmVHVEamRyVmdBUVR4bFlVR3psM3lpbWxGMVlQLWNvcjZ6ZHNnL2lzc3VlL2ZpbmFsaXplLW9mZmVycyJ9LCJwcmVzZW50YXRpb25fZGVmaW5pdGlvbiI6eyJpZCI6IjY1ZDVmNzc1ZjBkNmUxMzg4ODJlZWJjZS42NDI1NTI2N2RiMmFjYmIwNjMyZWQzYmQiLCJwdXJwb3NlIjoiU2ltcGxlIElzc3VpbmciLCJuYW1lIjoiU2hhcmUgeW91ciBJZCwgRW1haWwgYW5kIFBob25lIE51bWJlciB0byBmYWNpbGl0YXRlIHRoZSBzZWFyY2ggZm9yIHlvdXIgY2FyZWVyIGNyZWRlbnRpYWxzIiwiZm9ybWF0Ijp7Imp3dF92cCI6eyJhbGciOlsic2VjcDI1NmsxIl19fSwiaW5wdXRfZGVzY3JpcHRvcnMiOlt7ImlkIjoiRW1haWxWMS4wIiwibmFtZSI6IkVtYWlsIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL3FhbGliLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvZW1haWwtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfSx7ImlkIjoiUGhvbmVWMS4wIiwibmFtZSI6IlBob25lIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL3FhbGliLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvcGhvbmUtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfV0sInN1Ym1pc3Npb25fcmVxdWlyZW1lbnRzIjpbeyJydWxlIjoiYWxsIiwiZnJvbSI6IkEiLCJtaW4iOjJ9XX0sIm91dHB1dF9kZXNjcmlwdG9ycyI6W10sImlzc3VlciI6eyJpZCI6ImRpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZyJ9LCJuYmYiOjE3MDg1MjEzMzMsImlzcyI6ImRpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZyIsImV4cCI6MTcwOTEyNjEzMywiaWF0IjoxNzA4NTIxMzMzfQ.hddTeY6yvc654HwREHBCDmmQ0KoQSkEB065_mzhmk0C7l9YYZVu-nPWECIoJX07hYOoKf0fXa5bZYA7c_QDOUQ"
    
    static let JwtCredentialManifestForInvalidCredentialMicrsoftQa =
    "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NksiLCJraWQiOiJkaWQ6aW9uOkVpRDFxcjBaSmZUdURqZHJWZ0FRVHhsWVVHemwzeWltbEYxWVAtY29yNnpkc2cjZXhjaGFuZ2Uta2V5LTEifQ.eyJleGNoYW5nZV9pZCI6IjY1ZDVmNmI2YWVhZmJlNjVjOTliNzczZCIsIm1ldGFkYXRhIjp7ImNsaWVudF9uYW1lIjoiTWljcm9zb2Z0IENvcnBvcmF0aW9uIiwibG9nb191cmkiOiJodHRwczovL2Fnc29sLmNvbS93cC1jb250ZW50L3VwbG9hZHMvMjAxOC8wOS9uZXctbWljcm9zb2Z0LWxvZ28tU0laRUQtU1FVQVJFLmpwZyIsInRvc191cmkiOiJodHRwczovL3d3dy52ZWxvY2l0eWV4cGVyaWVuY2VjZW50ZXIuY29tL3Rlcm1zLWFuZC1jb25kaXRpb25zLXZuZiIsIm1heF9yZXRlbnRpb25fcGVyaW9kIjoiNm0iLCJwcm9ncmVzc191cmkiOiJodHRwczovL3FhYWdlbnQudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS9ob2xkZXIvdjAuNi9vcmcvZGlkOmlvbjpFaUQxcXIwWkpmVHVEamRyVmdBUVR4bFlVR3psM3lpbWxGMVlQLWNvcjZ6ZHNnL2dldC1leGNoYW5nZS1wcm9ncmVzcyIsInN1Ym1pdF9wcmVzZW50YXRpb25fdXJpIjoiaHR0cHM6Ly9xYWFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZy9pc3N1ZS9zdWJtaXQtaWRlbnRpZmljYXRpb24iLCJjaGVja19vZmZlcnNfdXJpIjoiaHR0cHM6Ly9xYWFnZW50LnZlbG9jaXR5Y2FyZWVybGFicy5pby9hcGkvaG9sZGVyL3YwLjYvb3JnL2RpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZy9pc3N1ZS9jcmVkZW50aWFsLW9mZmVycyIsImZpbmFsaXplX29mZmVyc191cmkiOiJodHRwczovL3FhYWdlbnQudmVsb2NpdHljYXJlZXJsYWJzLmlvL2FwaS9ob2xkZXIvdjAuNi9vcmcvZGlkOmlvbjpFaUQxcXIwWkpmVHVEamRyVmdBUVR4bFlVR3psM3lpbWxGMVlQLWNvcjZ6ZHNnL2lzc3VlL2ZpbmFsaXplLW9mZmVycyJ9LCJwcmVzZW50YXRpb25fZGVmaW5pdGlvbiI6eyJpZCI6IjY1ZDVmNmI2YWVhZmJlNjVjOTliNzczZC42NDI1NTI2N2RiMmFjYmIwNjMyZWQzYmQiLCJwdXJwb3NlIjoiU2ltcGxlIElzc3VpbmciLCJuYW1lIjoiU2hhcmUgeW91ciBJZCwgRW1haWwgYW5kIFBob25lIE51bWJlciB0byBmYWNpbGl0YXRlIHRoZSBzZWFyY2ggZm9yIHlvdXIgY2FyZWVyIGNyZWRlbnRpYWxzIiwiZm9ybWF0Ijp7Imp3dF92cCI6eyJhbGciOlsic2VjcDI1NmsxIl19fSwiaW5wdXRfZGVzY3JpcHRvcnMiOlt7ImlkIjoiRW1haWxWMS4wIiwibmFtZSI6IkVtYWlsIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL3FhbGliLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvZW1haWwtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfSx7ImlkIjoiUGhvbmVWMS4wIiwibmFtZSI6IlBob25lIiwic2NoZW1hIjpbeyJ1cmkiOiJodHRwczovL3FhbGliLnZlbG9jaXR5bmV0d29yay5mb3VuZGF0aW9uL3NjaGVtYXMvcGhvbmUtdjEuMC5zY2hlbWEuanNvbiJ9XSwiZ3JvdXAiOlsiQSJdfV0sInN1Ym1pc3Npb25fcmVxdWlyZW1lbnRzIjpbeyJydWxlIjoiYWxsIiwiZnJvbSI6IkEiLCJtaW4iOjJ9XX0sIm91dHB1dF9kZXNjcmlwdG9ycyI6W10sImlzc3VlciI6eyJpZCI6ImRpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZyJ9LCJuYmYiOjE3MDg1MjExNDMsImlzcyI6ImRpZDppb246RWlEMXFyMFpKZlR1RGpkclZnQVFUeGxZVUd6bDN5aW1sRjFZUC1jb3I2emRzZyIsImV4cCI6MTcwOTEyNTk0MywiaWF0IjoxNzA4NTIxMTQzfQ.zJ_Yd-tXYFm6DzhjJKHZJvv8ATo8ErCQqRLEWz7FG2rpPWpWYL1N73fotF1sgGnYKP3_8n7PxU2WQbzNswsElg"
    
}
