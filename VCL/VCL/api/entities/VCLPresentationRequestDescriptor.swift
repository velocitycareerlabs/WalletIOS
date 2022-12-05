//
//  VCLPresentationRequestDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 05/12/2022.
//

import Foundation

public class VCLPresentationRequestDescriptor {
    public let deepLink: VCLDeepLink
    public let pushDelegate: VCLPushDelegate?
    
    public init(deepLink: VCLDeepLink, pushDelegate: VCLPushDelegate? = nil) {
        self.deepLink = deepLink
        self.pushDelegate = pushDelegate
    }
    
    public struct CodingKeys {
        static let KeyId = "id"
        
        static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        static let KeyPushDelegatePushToken = "push_delegate.push_token"
    }
    
    var endpoint: String { get { if let queryParams = generateQueryParams() {
        return deepLink.requestUri.appendQueryParams(queryParams: queryParams)
    } else {
        return deepLink.requestUri
    }}}
    
    private func generateQueryParams() -> String? {
        var pPushDelegate = ""
        if let pd = pushDelegate {
            pPushDelegate = "\(CodingKeys.KeyPushDelegatePushUrl)=\(pd.pushUrl.encode() ?? "")&" + "\(CodingKeys.KeyPushDelegatePushToken)=\(pd.pushToken)"
        }
        let qParams = [pPushDelegate].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
