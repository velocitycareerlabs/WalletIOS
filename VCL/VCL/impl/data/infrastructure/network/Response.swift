//
//  Response.swift
//  VCL
//
//  Created by Michael Avoyan on 01/11/2021.
//

import Foundation

struct Response {
    let payload: Data
    let code: Int
    
    init(payload: Data, code: Int) {
        self.payload = payload
        self.code = code
    }
}
