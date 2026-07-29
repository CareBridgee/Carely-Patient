//
//  ProfileEndpoint.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//

import Foundation
import Alamofire

enum ProfileEndpoint: Endpoint {
    case getDefaultProfile
    case updateProfile(id: String, request: UpdateProfileRequestDTO)
    case saveMedicalConditions(profileId: String, request: MedicalConditionRequestDTO)
    case saveAllergies(profileId: String, request: AllergyRequestDTO)
    case saveMedications(profileId: String, request: MedicationRequestDTO)
    case saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO)
    case saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO)
    case saveAddress(profileId: String, request: AddressRequestDTO)

    var path: String {
        switch self {
        case .getDefaultProfile: return "/api/v1/profiles/default"
        case .updateProfile(let id, _): return "/api/v1/profiles/\(id)"
        case .saveMedicalConditions(let id, _): return "/api/v1/profiles/\(id)/medical-conditions"
        case .saveAllergies(let id, _): return "/api/v1/profiles/\(id)/allergies"
        case .saveMedications(let id, _): return "/api/v1/profiles/\(id)/medications"
        case .saveMedicalHistory(let id, _): return "/api/v1/profiles/\(id)/medical-history"
        case .saveEmergencyContact(let id, _): return "/api/v1/profiles/\(id)/emergency-contacts"
        case .saveAddress(let id, _): return "/api/v1/profiles/\(id)/address"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDefaultProfile: return .get
        case .updateProfile: return .put
        default: return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getDefaultProfile: return nil
        case .updateProfile(_, let req): return req.asParameters()
        case .saveMedicalConditions(_, let req): return req.asParameters()
        case .saveAllergies(_, let req): return req.asParameters()
        case .saveMedications(_, let req): return req.asParameters()
        case .saveMedicalHistory(_, let req): return req.asParameters()
        case .saveEmergencyContact(_, let req): return req.asParameters()
        case .saveAddress(_, let req): return req.asParameters()
        }
    }
    
    var authorizationType: AuthorizationType { return .bearer }
}
