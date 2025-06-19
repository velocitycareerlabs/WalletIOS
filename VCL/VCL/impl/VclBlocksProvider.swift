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
    
    static func chooseKeyService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> VCLKeyService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
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
    
    static func chooseJwtSignService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> VCLJwtSignService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLJwtSignServiceLocalImpl(
                try chooseKeyService(cryptoServicesDescriptor)
            )
            
        case VCLCryptoServiceType.Remote:
            if let jwtSignServiceUrl = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.jwtServiceUrls.jwtSignServiceUrl {
                return VCLJwtSignServiceRemoteImpl(
                    NetworkServiceImpl(),
                    jwtSignServiceUrl
                )
            } else {
                throw VCLError(errorCode: VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
            }
            
        case VCLCryptoServiceType.Injected:
            if let jwtSignService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.jwtSignService {
                return jwtSignService
            } else {
                throw VCLError(errorCode: VCLErrorCode.InjectedServicesNotFount.rawValue)
            }
        }
    }
    
    static func chooseJwtVerifyService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> VCLJwtVerifyService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLJwtVerifyServiceLocalImpl()
            
        case VCLCryptoServiceType.Remote:
            if let jwtVerifyServiceUrl = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.jwtServiceUrls.jwtVerifyServiceUrl {
                return VCLJwtVerifyServiceRemoteImpl(
                    NetworkServiceImpl(),
                    jwtVerifyServiceUrl
                )
            } else {
                return VCLJwtVerifyServiceLocalImpl() // verification may be done locally
            }
            
        case VCLCryptoServiceType.Injected:
            if let jwtVerifyService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.jwtVerifyService {
                return jwtVerifyService
            } else {
                return VCLJwtVerifyServiceLocalImpl() // verification may be done locally
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
                ExecutorImpl.instance
            )
        )
    }
    
    static func provideCredentialTypeSchemasModel(
        credenctiialTypes: VCLCredentialTypes
    ) -> CredentialTypeSchemasModel {
        return CredentialTypeSchemasModelImpl(
            CredentialTypeSchemasUseCaseImpl(
                CredentialTypeSchemaRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                credenctiialTypes,
                ExecutorImpl.instance,
                DispatcherImpl()
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
                ExecutorImpl.instance
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
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            PresentationRequestByDeepLinkVerifierImpl(),
            ExecutorImpl.instance
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
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideOrganizationsUseCase() -> OrganizationsUseCase {
        return OrganizationsUseCaseImpl(
            OrganizationsRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideCredentialManifestUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> CredentialManifestUseCase {
        return CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            CredentialManifestByDeepLinkVerifierImpl(),
            ExecutorImpl.instance
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
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideExchangeProgressUseCase() -> ExchangeProgressUseCase {
        return ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideGenerateOffersUseCase() -> GenerateOffersUseCase {
        return GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceImpl()
            ),
            OffersByDeepLinkVerifierImpl(
                ResolveDidDocumentRepositoryImpl(
                    NetworkServiceImpl()
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideFinalizeOffersUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        _ credentialTypesModel: CredentialTypesModel,
        _ isDirectIssuerCheckOn: Bool
    ) throws -> FinalizeOffersUseCase {
        var credentialIssuerVerifier: CredentialIssuerVerifier = CredentialIssuerVerifierEmptyImpl()
        if (isDirectIssuerCheckOn) {
            credentialIssuerVerifier = CredentialIssuerVerifierImpl(
                credentialTypesModel,
                NetworkServiceImpl(),
                ExecutorImpl.instance
            )
        }
        return FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceImpl()),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            credentialIssuerVerifier,
            CredentialDidVerifierImpl(),
            CredentialsByDeepLinkVerifierImpl(
                ResolveDidDocumentRepositoryImpl(
                    NetworkServiceImpl()
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideAuthTokenUseCase() -> AuthTokenUseCase {
        return AuthTokenUseCaseImpl(
            AuthTokenRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideCredentialTypesUIFormSchemaUseCase() -> CredentialTypesUIFormSchemaUseCase {
        return CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl.instance,
            DispatcherImpl()
        )
    }
    
    static func provideVerifiedProfileUseCase() -> VerifiedProfileUseCase {
        return VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideJwtServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> JwtServiceUseCase {
        return JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(cryptoServicesDescriptor),
                try chooseJwtVerifyService(cryptoServicesDescriptor)
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideKeyServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor
    ) throws -> KeyServiceUseCase {
        return KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                try chooseKeyService(cryptoServicesDescriptor)
            ),
            ExecutorImpl.instance
        )
    }
}
