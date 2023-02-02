//
//  VCLPresentationRequestDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 05/12/2022.
//

import Foundation

public class VCLPresentationRequestDescriptor {
    public let deepLink: VCLDeepLink
    public let serviceType: VCLServiceType
    public let pushDelegate: VCLPushDelegate?
    
    public init(
        deepLink: VCLDeepLink,
        serviceType: VCLServiceType = VCLServiceType.Inspector,
        pushDelegate: VCLPushDelegate? = nil
    ) {
        self.deepLink = deepLink
        self.serviceType = serviceType
        self.pushDelegate = pushDelegate
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
        static let KeyId = "id"
        
        static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        static let KeyPushDelegatePushToken = "push_delegate.push_token"
    }
}
