//
//  PresentationRequestRepository.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//

import Foundation

protocol PresentationRequestRepository {
    func getPresentationRequest(deepLink: VCLDeepLink, completionBlock: @escaping (VCLResult<String>) -> Void)
}
