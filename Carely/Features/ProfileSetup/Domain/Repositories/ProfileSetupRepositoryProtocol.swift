//
//  ProfileSetupRepositoryProtocol.swift
//  Carely
//

import Foundation
import CoreLocation

protocol ProfileSetupRepositoryProtocol {
    func updateSearchQuery(_ query: String)
    func setSearchSuggestionsHandler(_ handler: @escaping ([SearchSuggestion]) -> Void)
    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D
    func reverseGeocode(latitude: Double, longitude: Double) async throws -> AddressSelection
    func geocodeCountry(_ country: String) async throws -> CLLocationCoordinate2D?
    func geocodeAddress(_ addressString: String) async throws -> CLLocationCoordinate2D?
    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D?
    func requestCurrentLocationAddress() async throws -> AddressSelection
    func fetchDefaultProfileId() async throws -> String
        func updateBasicInfo(profileId: String, info: BasicHealthInfo) async throws
        func updateMobility(profileId: String, mobility: Mobility) async throws
    func fetchAllMedicalConditions() async throws -> [MedicalCondition]
    func fetchProfileMedicalConditions(profileId: String) async throws -> Set<String>
    func addMedicalCondition(profileId: String, condition: MedicalCondition) async throws
    func removeMedicalCondition(profileId: String, medicalConditionId: String) async throws
    func fetchAllAllergies() async throws -> [Allergy]
    func fetchProfileAllergies(profileId: String) async throws -> Set<String>
    func addAllergy(profileId: String, allergy: Allergy) async throws
    func removeAllergy(profileId: String, allergyId: String) async throws
    func fetchProfileMedications(profileId: String) async throws -> [PatientMedication]
    func addMedication(profileId: String, name: String) async throws -> PatientMedication
    func removeMedication(profileId: String, medicationId: String) async throws
        func saveMedicalHistory(profileId: String, history: MedicalHistory) async throws
        func fetchEmergencyContact(profileId: String) async throws -> EmergencyContact?
        func saveEmergencyContact(profileId: String, contact: EmergencyContact) async throws
        func updateEmergencyContact(contactId: String, contact: EmergencyContact) async throws
        func saveAddress(profileId: String, address: HomeAddress) async throws
    func createFamilyMemberProfile(_ info: FamilyMemberBasicInfo) async throws -> String
    func updateAddress(profileId: String, address: HomeAddress) async throws
    func fetchAddress(profileId: String) async throws -> HomeAddress?
}
