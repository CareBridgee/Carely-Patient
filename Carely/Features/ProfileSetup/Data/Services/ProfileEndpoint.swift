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
    case createProfile(request: CreateProfileRequestDTO)

    case updateProfile(id: String, request: UpdateProfileRequestDTO)
    case getAllMedicalConditions
    case getProfileMedicalConditions(profileId: String)
    case addMedicalCondition(profileId: String, request: AddMedicalConditionRequestDTO)
    case removeMedicalCondition(profileId: String, medicalConditionId: String)
    case getAllAllergies
    case getProfileAllergies(profileId: String)
    case addAllergy(profileId: String, request: AddAllergyRequestDTO)
    case removeAllergy(profileId: String, allergyId: String)
    case getProfileMedications(profileId: String)
    case addMedication(profileId: String, request: AddMedicationRequestDTO)
    case removeMedication(profileId: String, medicationId: String)
    case saveMedicalHistory(profileId: String, request: MedicalHistoryRequestDTO)
    case getEmergencyContacts(profileId: String)
    case saveEmergencyContact(profileId: String, request: EmergencyContactRequestDTO)
    case updateEmergencyContact(contactId: String, request: EmergencyContactRequestDTO)
    case saveAddress(profileId: String, request: AddressRequestDTO)
    case updateAddress(profileId: String, request: AddressRequestDTO)
    case getAddress(profileId: String)

    var path: String {
        switch self {
        case .getDefaultProfile: return "/api/v1/profiles/default"
        case .createProfile: return "/api/v1/profiles"
        case .updateProfile(let id, _): return "/api/v1/profiles/\(id)"
        case .getAllMedicalConditions: return "/api/v1/medical-conditions"
        case .getProfileMedicalConditions(let id): return "/api/v1/profiles/\(id)/medical-conditions"
        case .addMedicalCondition(let id, _): return "/api/v1/profiles/\(id)/medical-conditions"
        case .removeMedicalCondition(let id, let mcId): return "/api/v1/profiles/\(id)/medical-conditions/\(mcId)"
        case .getAllAllergies: return "/api/v1/allergies"
        case .getProfileAllergies(let id): return "/api/v1/profiles/\(id)/allergies"
        case .addAllergy(let id, _): return "/api/v1/profiles/\(id)/allergies"
        case .removeAllergy(let id, let aId): return "/api/v1/profiles/\(id)/allergies/\(aId)"
        case .getProfileMedications(let id): return "/api/v1/profiles/\(id)/medications"
        case .addMedication(let id, _): return "/api/v1/profiles/\(id)/medications"
        case .removeMedication(let id, let mId): return "/api/v1/profiles/\(id)/medications/\(mId)"
        case .saveMedicalHistory(let id, _): return "/api/v1/profiles/\(id)/medical-history"
        case .getEmergencyContacts(let id): return "/api/v1/profiles/\(id)/emergency-contacts"
        case .saveEmergencyContact(let id, _): return "/api/v1/profiles/\(id)/emergency-contacts"
        case .updateEmergencyContact(let cId, _): return "/api/v1/emergency-contacts/\(cId)"
        case .saveAddress(let id, _): return "/api/v1/profiles/\(id)/address"
        case .updateAddress(let id, _): return "/api/v1/profiles/\(id)/address"
        case .getAddress(let id): return "/api/v1/profiles/\(id)/address"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getDefaultProfile, .getAddress, .getAllMedicalConditions, .getProfileMedicalConditions, .getAllAllergies, .getProfileAllergies, .getProfileMedications, .getEmergencyContacts: return .get
        case .updateProfile, .updateAddress, .updateEmergencyContact: return .put
        case .removeMedicalCondition, .removeAllergy, .removeMedication: return .delete
        default: return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .getDefaultProfile, .getAddress, .getAllMedicalConditions, .getProfileMedicalConditions, .removeMedicalCondition, .getAllAllergies, .getProfileAllergies, .removeAllergy, .getProfileMedications, .removeMedication, .getEmergencyContacts: return nil
        case .createProfile(let req): return req.asParameters()
        case .updateProfile(_, let req): return req.asParameters()
        case .addMedicalCondition(_, let req): return req.asParameters()
        case .addAllergy(_, let req): return req.asParameters()
        case .addMedication(_, let req): return req.asParameters()
        case .saveMedicalHistory(_, let req): return req.asParameters()
        case .saveEmergencyContact(_, let req): return req.asParameters()
        case .updateEmergencyContact(_, let req): return req.asParameters()
        case .saveAddress(_, let req): return req.asParameters()
        case .updateAddress(_, let req): return req.asParameters()  
        }
    }
    
    var authorizationType: AuthorizationType { return .bearer }
}


   

    
