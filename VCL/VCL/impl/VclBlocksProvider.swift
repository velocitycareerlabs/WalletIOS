//
//  SdkBlocksProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 19/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VclBlocksProvider {
    
    private init(){}
    
    internal static func chooseKeyService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> VCLKeyService {
        switch(cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLKeyServiceLocalImpl()
            
        case VCLCryptoServiceType.Remote:
            if let keyServiceUrls = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.keyServiceUrls {
                return VCLKeyServiceRemoteImpl(
                    NetworkServiceImpl(),
                    keyServiceUrls
                )
            } else {
                throw VCLError(errorCode: VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
            }
            
        case VCLCryptoServiceType.Injected:
            if let keyService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.keyService {
                return keyService
            } else {
                throw VCLError(errorCode: VCLErrorCode.InjectedServicesNotFount.rawValue)
            }
        }
    }
    
    internal static func chooseJwtService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> VCLJwtService {
        switch(cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLJwtServiceLocalImpl(try chooseKeyService(cryptoServicesDescriptor))
            
        case VCLCryptoServiceType.Remote:
            if let jwtServiceUrls = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.jwtServiceUrls {
                return VCLJwtServiceRemoteImpl(
                    NetworkServiceImpl(),
                    jwtServiceUrls
                )
            } else {
                throw VCLError(errorCode: VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
            }
        case VCLCryptoServiceType.Injected:
            if let jwtService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.jwtService {
                return jwtService
            } else {
                throw VCLError(errorCode: VCLErrorCode.InjectedServicesNotFount.rawValue)
            }
        }
    }
    
    static func provideCountriesModel() -> CountriesModel {
        return CountriesModelImpl(
            CountriesUseCaseImpl(
                CountriesRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                ExecutorImpl()
            )
        )
    }
    
    static func provideCredentialTypeSchemasModel(credenctiialTypes: VCLCredentialTypes) -> CredentialTypeSchemasModel {
        return CredentialTypeSchemasModelImpl(
            CredentialTypeSchemasUseCaseImpl(
                CredentialTypeSchemaRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                credenctiialTypes,
                ExecutorImpl(),
                DispatcherImpl(),
                DsptchQueueImpl("CredentialTypeSchemas")
            )
        )
    }
    
    static func provideCredentialTypesModel() -> CredentialTypesModel {
        return CredentialTypesModelImpl(
            CredentialTypesUseCaseImpl(
                CredentialTypesRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                ExecutorImpl()
            )
        )
    }
    
    static func providePresentationRequestUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> PresentationRequestUseCase {
        return PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
    
    static func providePresentationSubmissionUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> PresentationSubmissionUseCase {
        return PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideOrganizationsUseCase() -> OrganizationsUseCase {
        return OrganizationsUseCaseImpl(
            OrganizationsRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideCredentialManifestUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> CredentialManifestUseCase {
        return CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideIdentificationSubmissionUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> IdentificationSubmissionUseCase {
        return IdentificationSubmissionUseCaseImpl(
            IdentificationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideExchangeProgressUseCase() -> ExchangeProgressUseCase {
        return ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideGenerateOffersUseCase() -> GenerateOffersUseCase {
        return GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideFinalizeOffersUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        _ credentialTypesModel: CredentialTypesModel
    ) throws -> FinalizeOffersUseCase {
        return FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceImpl()),
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
//            CredentialIssuerVerifierImpl(
//                credentialTypesModel,
//                NetworkServiceImpl()
//            ),
            CredentialIssuerVerifierEmptyImpl(),
            CredentialDidVerifierImpl(),
            ExecutorImpl()
        )
    }
    
    static func provideCredentialTypesUIFormSchemaUseCase() -> CredentialTypesUIFormSchemaUseCase {
        return CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl(),
            DispatcherImpl()
        )
    }
    
    static func provideVerifiedProfileUseCase() -> VerifiedProfileUseCase {
        return VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideJwtServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> JwtServiceUseCase {
        return JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                try chooseJwtService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideKeyServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> KeyServiceUseCase {
        return KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                try chooseKeyService(cryptoServicesDescriptor)
            ),
            ExecutorImpl()
        )
    }
}
