//
//  NurseEndpoint.swift
//  Carely
//
//  Created by Mina on 08/08/2026.
//

import Alamofire
import Foundation

enum NurseEndpoint: Endpoint {
    case getNurse(id: String)

    var path: String {
        switch self {
        case .getNurse(let id):
            return "/api/v1/nurses/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getNurse:
            return .get
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .getNurse:
            // Requires a signed-in user; AuthInterceptor attaches the
            // access token automatically (falls back to Endpoint default .bearer).
            return .bearer
        }
    }
}
