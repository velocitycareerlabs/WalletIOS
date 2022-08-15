//
//  PresentationRequestUseCase.swift
//  
//
//  Created by Michael Avoyan on 01/04/2021.
//

import Foundation

protocol PresentationRequestUseCase {
    func getPresentationRequest(deepLink: VCLDeepLink, completionBlock: @escaping (VCLResult<VCLPresentationRequest>) -> Void)
}
