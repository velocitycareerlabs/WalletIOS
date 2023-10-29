//
//  ServiceTypesRepositoryImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 26/10/2023.
//

import Foundation

class ServiceTypesRepositoryImpl: ServiceTypesRepository {
    
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(
        _ networkService: NetworkService, 
        _ cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func getServiceTypes(
        cacheSequence: Int,
        completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    ) {
        let endpoint = Urls.ServiceTypes
        if (cacheService.isResetCacheServiceTypes(cacheSequence: cacheSequence)) {
            fetchServiceTypes(endpoint, cacheSequence, completionBlock)
        } else {
            if let serviceTypesData = cacheService.getServiceTypes(key: endpoint) {
                if let serviceTypes =  parse(serviceTypesData.toDictionary()) {
                    completionBlock(.success(serviceTypes))
                } else {
                    completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: serviceTypesData, encoding: .utf8) ?? "")")))
                }
            } else {
                fetchServiceTypes(endpoint, cacheSequence, completionBlock)
            }
        }
    }
    
    private func fetchServiceTypes(
        _ endpoint: String,
        _ cacheSequence: Int,
        _ completionBlock: @escaping (VCLResult<VCLServiceTypesDynamic>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: endpoint,
            contentType: Request.ContentType.ApplicationJson,
            method: Request.HttpMethod.GET,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)],
            completionBlock: { [weak self] result in
                do {
                    let serviceTypesData = try result.get().payload
                    self?.cacheService.setServiceTypes(
                        key: endpoint,
                        value: serviceTypesData,
                        cacheSequence: cacheSequence
                    )
                    if let serviceTypes =  self?.parse(serviceTypesData.toDictionary()) {
                        completionBlock(.success(serviceTypes))
                    } else {
                        completionBlock(.failure(VCLError(message: "Failed to parse \(String(data: serviceTypesData, encoding: .utf8) ?? "")")))
                    }
                } catch {
                    completionBlock(.failure(error as? VCLError ?? VCLError(error: error)))
                }
            }
        )
    }
    
    private func parse(_ serviceTypesJsonObj: [String: Any]?) -> VCLServiceTypesDynamic? {
        if let serviceTypesJsonArr = 
            serviceTypesJsonObj?[VCLServiceTypesDynamic.CodingKeys.KeyServiceTypes] as? [Any] {
            var serviceTypesArr = [VCLServiceTypeDynamic]()
            serviceTypesJsonArr.forEach {
                if let payload = $0 as? [String: Any] {
                    serviceTypesArr.append(VCLServiceTypeDynamic(payload: payload))
                }
            }
            return VCLServiceTypesDynamic(all: serviceTypesArr)
        } else {
            return nil
        }
    }
}
