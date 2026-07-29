//
//  ProfileEndpoint.swift
//  Carely
//

import Foundation
import Alamofire

enum ProfileEndpoint: Endpoint {
    case getDefaultProfile
    case updateBasicInfo(id: String, parameters: Parameters)
    case saveMedicalHistory(profileId: String, parameters: Parameters)
    case saveEmergencyContact(profileId: String, parameters: Parameters)
    case saveAddress(profileId: String, parameters: Parameters)

    var path: String {
        switch self {
        case .getDefaultProfile:
            return "/api/v1/profiles/default"
        case .updateBasicInfo(let id, _):
            return "/api/v1/profiles/\(id)"
        case .saveMedicalHistory(let profileId, _):
            return "/api/v1/profiles/\(profileId)/medical-history"
        case .saveEmergencyContact(let profileId, _):
            return "/api/v1/profiles/\(profileId)/emergency-contacts"
        case .saveAddress(let profileId, _):
            return "/api/v1/profiles/\(profileId)/address"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDefaultProfile: return .get
        case .updateBasicInfo: return .put
        case .saveMedicalHistory, .saveEmergencyContact, .saveAddress: return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getDefaultProfile: return nil
        case .updateBasicInfo(_, let params),
             .saveMedicalHistory(_, let params),
             .saveEmergencyContact(_, let params),
             .saveAddress(_, let params):
            return params
        }
    }
    
    var authorizationType: AuthorizationType { return .bearer }
}