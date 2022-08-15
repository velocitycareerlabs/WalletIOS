//
//  VCLJWT.swift
//  
//
//  Created by Michael Avoyan on 26/04/2021.
//

import Foundation
import VCToken

public struct VCLJWT {
    public private(set) var header: [String: Any]? = nil
    public private(set) var payload: [String: Any]? = nil
    public private(set) var signature: String? = nil
    public private(set) var encodedJwt: String = ""
    
    public private(set) var jwsToken: JwsToken<VCLClaims>? = nil
    
    public init(header: [String: Any]?, payload: [String: Any]?, signature: String?, encodedJwt: String) {
        initialize(header: header, payload: payload, signature: signature, encodedJwt: encodedJwt)
    }
    
    public init(encodedJwt: String) {
        let decodedJwt = encodedJwt.decodeJwtBase64Url()
        initialize(header: decodedJwt[0].toDictionary(),
                   payload: decodedJwt[1].toDictionary(),
                   signature: decodedJwt[2],
                   encodedJwt: encodedJwt)
    }
    
    private mutating func initialize(header: [String: Any]?, payload: [String: Any]?, signature: String?, encodedJwt: String) {
        self.header = header
        self.payload = payload
        self.signature = signature
        self.encodedJwt = encodedJwt
        
        self.jwsToken = JwsToken<VCLClaims>(from: encodedJwt)
        
        
//        "typ": "JWT",
//        "kid": "did:velocity:0x6c0d8bcce17652ff5af352129415dca5637bb20e",
//        "alg": "ES256K"
//        let jwsHeader = Header(type: header?[CodingKeys.KeyTyp] as? String,
//                               algorithm: header?[CodingKeys.KeyAlg] as? String,
//                               keyId: header?[CodingKeys.KeyKid] as? String)
        
//        self.jwsToken = JwsToken<VCLClaims>(headers: jwsHeader,
//                                            content: VCLFClaims(jwtMap: payload ?? [:]),
//                                            signature: Data(base64URLEncoded: self.signature ?? ""))
    }
    
    struct CodingKeys {
        static let KeyTyp = "typ"
        static let KeyAlg = "alg"
        static let KeyKid = "kid"
        static let KeyJwk = "jwk"
        
        static let KeyX = "x"
        static let KeyY = "y"
        
        static let KeyHeader = "header"
        static let KeyPayload = "payload"
        static let KeySignature = "signature"
    }
    
    var keyID: String? { get {
        return (header?[CodingKeys.KeyKid] as? String) ?? ((header?[CodingKeys.KeyJwk] as? [String: Any])?[CodingKeys.KeyKid]) as? String
    } }
}
