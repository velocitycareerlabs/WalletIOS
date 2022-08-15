//
//  CredentialTypeSchemasModelImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//

class CredentialTypeSchemasModelImpl: CredentialTypeSchemasModel {
    
    private(set) var data: VCLCredentialTypeSchemas?
    let credentialTypeSchemasUseCase: CredentialTypeSchemasUseCase
    
    init(_ credentialTypeSchemasUseCase: CredentialTypeSchemasUseCase) {
        self.credentialTypeSchemasUseCase = credentialTypeSchemasUseCase
    }
    
    func initialize(completionBlock: @escaping (VCLResult<VCLCredentialTypeSchemas>) -> Void) {
        credentialTypeSchemasUseCase.getCredentialTypeSchemas { [weak self] result in
            do {
                self?.data = try result.get()
            } catch {}
            completionBlock(result)
        }
    }
}
