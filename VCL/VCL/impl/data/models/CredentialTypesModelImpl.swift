//
//  CredentialTypesModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//

class CredentialTypesModelImpl: CredentialTypesModel {
    
    private(set) var data: VCLCredentialTypes? = nil
    let credentialTypesUseCase: CredentialTypesUseCase
    
    init(_ credentialTypesUseCase: CredentialTypesUseCase) {
        self.credentialTypesUseCase = credentialTypesUseCase
    }
    
    func initialize(completionBlock: @escaping (VCLResult<VCLCredentialTypes>) -> Void) {
        credentialTypesUseCase.getCredentialTypes { [weak self] response in
            do {
                self?.data = try response.get()
            } catch {}
            completionBlock(response)
        }
    }
}
