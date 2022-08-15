//
//  VCLCredentialManifestDescriptorByDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//

import Foundation

public class VCLCredentialManifestDescriptorByDeepLink: VCLCredentialManifestDescriptor {
    public init(deepLink: VCLDeepLink) {
        super.init(uri: deepLink.requestUri)
    }
}
