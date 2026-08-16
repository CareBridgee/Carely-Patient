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
    case acceptOffer(offerId: String)
    case declineOffer(offerId: String)
    case cancelServiceRequest(serviceRequestId: String)
    case fetchVisitCode(serviceRequestId: String)

    var path: String {
        switch self {
        case .getProfiles: return "/api/v1/profiles"
        case .getAddress(let profileId): return "/api/v1/profiles/\(profileId)/address"
        case .submitServiceRequest: return "/api/v1/service-requests"
        case .acceptOffer(let offerId): return "/api/v1/nurse-offers/\(offerId)/accept"
        case .declineOffer(let offerId): return "/api/v1/nurse-offers/\(offerId)/reject"
        case .cancelServiceRequest(let id): return "/api/v1/service-requests/\(id)/cancel"
        case .fetchVisitCode(let id): return "/api/v1/service-requests/\(id)/visit-code"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getProfiles, .getAddress: return .get
        case .submitServiceRequest, .fetchVisitCode: return .post
        case .acceptOffer, .declineOffer, .cancelServiceRequest: return .patch
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getProfiles, .getAddress, .acceptOffer, .declineOffer, .cancelServiceRequest, .fetchVisitCode: return nil
        case .submitServiceRequest(let body): return body.asParameters()
        }
    }
}
