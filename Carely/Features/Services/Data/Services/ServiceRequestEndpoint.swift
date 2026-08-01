//
//  ServiceRequestEndpoint.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Alamofire
import Foundation

enum ServiceRequestEndpoint: Endpoint {
    case getProfiles
    case getAddress(profileId: String)
    case submitServiceRequest(ServiceRequestBodyDTO)

    var path: String {
        switch self {
        case .getProfiles: return "/api/v1/profiles"
        case .getAddress(let profileId): return "/api/v1/profiles/\(profileId)/address"
        case .submitServiceRequest: return "/api/v1/service-requests"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfiles, .getAddress: return .get
        case .submitServiceRequest: return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getProfiles, .getAddress: return nil
        case .submitServiceRequest(let body): return body.asParameters()
        }
    }
}