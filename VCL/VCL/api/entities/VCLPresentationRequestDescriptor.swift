//
//  VCLPresentationRequestDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 05/12/2022.
//

import Foundation

public struct VCLPresentationRequestDescriptor: Sendable {
    public let deepLink: VCLDeepLink
    public let pushDelegate: VCLPushDelegate?
    public let didJwk: VCLDidJwk
    public let remoteCryptoServicesToken: VCLToken?
    
    public init(
        deepLink: VCLDeepLink,
        pushDelegate: VCLPushDelegate? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.deepLink = deepLink
        self.pushDelegate = pushDelegate
        self.didJwk = didJwk
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
    }
    
    var endpoint: String? { get {
        if let queryParams = generateQueryParams() {
            return deepLink.requestUri?.appendQueryParams(queryParams: queryParams)
        } else {
            return deepLink.requestUri
        }}
    }
    
    var did: String? { get { deepLink.did } }
    
    private func generateQueryParams() -> String? {
        var pPushDelegate = ""
        if let pd = pushDelegate {
            pPushDelegate = "\(CodingKeys.KeyPushDelegatePushUrl)=\(pd.pushUrl.encode() ?? "")&" + "\(CodingKeys.KeyPushDelegatePushToken)=\(pd.pushToken)"
        }
        let qParams = [pPushDelegate].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
    
    public struct CodingKeys {
        public static let KeyId = "id"
        
        public static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        public static let KeyPushDelegatePushToken = "push_delegate.push_token"
    }
}
