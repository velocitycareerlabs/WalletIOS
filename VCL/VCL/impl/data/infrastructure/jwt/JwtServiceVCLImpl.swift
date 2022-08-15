//
//  JwtServiceVCLImpl.swift
//  
//
//  Created by Michael Avoyan on 07/04/2021.
//

import Foundation

class JwtServiceVCLImpl: JwtService {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    private static let BaseUrl = "https://devservices.velocitycareerlabs.io"
    private static let DecodeUrl = "\(BaseUrl)/jwt/decode"
    private static let VerifyUrl = "\(BaseUrl)/jwt/verify"
    private static let SignUrl = "\(BaseUrl)/jwt/sign"
    
    func decode(encodedJwt: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        let jwtJson = ["jwt": encodedJwt]
        networkService.sendRequest(endpoint: JwtServiceVCLImpl.DecodeUrl,
                                   body: jwtJson.toJsonString(),
                                   contentType: .ApplicationJson,
                                   method: .POST) { response in
            do {
                let decodedJwtResponse = try response.get()
                if let decodedJwt = decodedJwtResponse.payload.toDictionary() {
                    completionBlock(.success(VCLJWT(
                        header: decodedJwt[VCLJWT.CodingKeys.KeyHeader] as? [String : Any],
                        payload: decodedJwt[VCLJWT.CodingKeys.KeyPayload] as? [String : Any],
                        signature: decodedJwt[VCLJWT.CodingKeys.KeySignature] as? String,
                        encodedJwt: encodedJwt
                        )
                    ))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to decode \(encodedJwt)")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func encode(jwt: String, completionBlock: @escaping (VCLResult<String>) -> Void) {
        completionBlock(.failure(VCLError(description: "Not implemented")))
    }
    
    func verify(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void) {
        let jwtJson: [String: Any] = ["jwt": jwt.encodedJwt, "publicKey": publicKey.jwkDict]
        networkService.sendRequest(endpoint: JwtServiceVCLImpl.VerifyUrl,
                                   body: jwtJson.toJsonString(),
                                   contentType: .ApplicationJson,
                                   method: .POST) {
            response in
            do {
                let isVerifiedResponse = try response.get()
                let isVerified = (String(data: isVerifiedResponse.payload, encoding: .utf8)?.toDictionary()? ["verified"] as? Int) == 1
                completionBlock(.success(isVerified))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func sign(payload: [String: Any], iss: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        networkService.sendRequest(endpoint: JwtServiceVCLImpl.SignUrl,
                                   body: generateBodyForSigning(payload, iss).toJsonString(),
                                   contentType: .ApplicationJson,
                                   method: .POST) {
            response in
            do {
                let signResponse = try response.get()
                if let jwtStr = signResponse.payload.toDictionary()? ["jwt"] as? String {
                    completionBlock(.success(VCLJWT(encodedJwt: jwtStr)))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to sign \(payload)")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generateBodyForSigning(_ payload: [String: Any], _ iss: String) -> [String: Any] {
        let issuer = UUID().uuidString
        let options = [
            "issuer": issuer,
            "audience": iss,
            "subject": issuer, // doesn't has any real usage
            "expiresIn": Date().addDaysToNow(days: 7).getDurationFromNow()
        ]
        let retVal = ["payload": payload, "options": options]
        return retVal
    }
}
