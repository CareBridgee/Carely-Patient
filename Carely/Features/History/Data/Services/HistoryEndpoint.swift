//
//  HistoryEndpoint.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Alamofire
import Foundation
 
enum HistoryEndpoint: Endpoint {
    case getConfirmedRequests
    case getRequestDetail(id: String)
    case getCurrentServiceRequest
 
    var path: String {
        switch self {
        case .getConfirmedRequests: return "/api/v1/service-requests/confirmed"
        case .getRequestDetail(let id): return "/api/v1/service-requests/\(id)"
        case .getCurrentServiceRequest: return "/api/v1/service-requests/current"
        }
    }
 
    var method: HTTPMethod {
        .get
    }
}
 
