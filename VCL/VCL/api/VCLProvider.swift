//
//  VCLProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//

public class VCLProvider {
    
    private init(){}
    
    public static func vclInstance() -> VCL {
        return VCLImpl()
    }
}
