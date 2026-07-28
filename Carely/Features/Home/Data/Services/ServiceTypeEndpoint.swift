//
//  ServiceTypeEndpoint.swift
//  Carely
//
//  Created by Mina on 28/07/2026.
//

import Alamofire
import Foundation

enum ServiceTypeEndpoint: Endpoint {
    case getServiceTypes
    case getServiceType(id: String)

    var path: String {
        switch self {
        case .getServiceTypes:
            return "/api/v1/service-types"
        case .getServiceType(let id):
            return "/api/v1/service-types/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getServiceTypes, .getServiceType:
            return .get
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getServiceTypes:
            // Public catalog listing - no bearer token required.
            return .none
        case .getServiceType:
            // Requires a signed-in user; falls back to the Endpoint default (.bearer),
            // so AuthInterceptor attaches the access token automatically.
            return .bearer
        }
    }
}
