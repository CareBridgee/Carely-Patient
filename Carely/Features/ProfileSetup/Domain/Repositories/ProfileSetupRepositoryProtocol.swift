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
    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D?
    func requestCurrentLocationAddress() async throws -> AddressSelection
    func fetchDefaultProfileId() async throws -> String
        func updateBasicInfo(profileId: String, info: BasicHealthInfo) async throws
        func updateMobility(profileId: String, mobility: Mobility) async throws
        func saveMedicalConditions(profileId: String, conditions: ExistingConditions) async throws
        func saveAllergies(profileId: String, allergies: Allergies) async throws
        func saveMedications(profileId: String, medications: CurrentMedication) async throws
        func saveMedicalHistory(profileId: String, history: MedicalHistory) async throws
        func saveEmergencyContact(profileId: String, contact: EmergencyContact) async throws
        func saveAddress(profileId: String, address: HomeAddress) async throws
    func createFamilyMemberProfile(_ info: FamilyMemberBasicInfo) async throws -> String
    func updateAddress(profileId: String, address: HomeAddress) async throws
}
