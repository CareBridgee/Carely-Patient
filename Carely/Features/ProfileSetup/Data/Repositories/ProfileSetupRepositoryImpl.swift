//
//  ProfileSetupRepositoryImpl.swift
//  Carely
//

import Foundation
import CoreLocation
import Combine

final class ProfileSetupRepositoryImpl: ProfileSetupRepositoryProtocol {

    // MARK: - Services (private implementation details)

    private let searchService: MapSearchService
    private let geocodingService: GeocodingService
    private let locationProvider: CurrentLocationProviderProtocol
    private let service: ProfileSetupServiceProtocol
    // MARK: - Internal Combine pipeline (never leaks past this boundary)

    private var cancellable: AnyCancellable?
    private var suggestionsHandler: (([SearchSuggestion]) -> Void)?

    // MARK: - Init

    init(
        searchService: MapSearchService,
        geocodingService: GeocodingService,
        locationProvider: CurrentLocationProviderProtocol,
        service: ProfileSetupServiceProtocol
    ) {
        self.searchService = searchService
        self.geocodingService = geocodingService
        self.locationProvider = locationProvider
        self.service = service
    }

    // MARK: - Search

    func updateSearchQuery(_ query: String) {
        searchService.updateSearchQuery(query)
    }

    func setSearchSuggestionsHandler(_ handler: @escaping ([SearchSuggestion]) -> Void) {
        suggestionsHandler = handler
        cancellable = searchService.searchSuggestions()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] suggestions in
                self?.suggestionsHandler?(suggestions)
            }
    }

    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D {
        return try await searchService.resolveLocation(for: suggestion)
    }

    // MARK: - Geocoding

    func reverseGeocode(latitude: Double, longitude: Double) async throws -> AddressSelection {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await geocodingService.reverseGeocodeLocation(location)

        guard let placemark = placemarks.first else {
            throw HomeAddressRepositoryError.reverseGeocodeFailed
        }

        let country = placemark.country ?? ""
        let city = placemark.locality ?? ""
        let area = placemark.subLocality ?? placemark.administrativeArea ?? ""
        let street = [placemark.thoroughfare, placemark.subThoroughfare]
            .compactMap { $0 }
            .joined(separator: " ")

        return AddressSelection(
            country: country,
            city: city,
            area: area,
            street: street,
            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        )
    }

    func geocodeCountry(_ country: String) async throws -> CLLocationCoordinate2D? {
        let placemarks = try await geocodingService.geocodeAddressString(country)
        return placemarks.first?.location?.coordinate
    }

    // MARK: - Location

    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D? {
        return await locationProvider.currentCoordinateIfAuthorized()
    }

    func requestCurrentLocationAddress() async throws -> AddressSelection {
        guard let coordinate = await locationProvider.requestCurrentCoordinate() else {
            throw HomeAddressRepositoryError.locationUnavailable
        }
        return try await reverseGeocode(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    func fetchDefaultProfileId() async throws -> String {
            return try await service.fetchDefaultProfileId()
        }

        func updateBasicInfo(profileId: String, info: BasicHealthInfo) async throws {
            let request = UpdateProfileRequestDTO(height: info.height, weight: info.weight, bloodType: info.bloodType)
            try await service.updateProfile(id: profileId, request: request)
        }
        
    func updateMobility(profileId: String, mobility: Mobility) async throws {
    
            let request = UpdateProfileRequestDTO(
                mobilityStatus: mobility.status?.title,
                mobilityNotes: mobility.additionalNotes
            )
            try await service.updateProfile(id: profileId, request: request)
        }
    func saveMedicalHistory(profileId: String, history: MedicalHistory) async throws {
            let request = UpdateProfileRequestDTO(
                previousSurgeries: history.previousSurgeries,
                previousHospitalizations: history.previousHospitalizations
            )
            try await service.updateProfile(id: profileId, request: request)
        }
    func fetchAllMedicalConditions() async throws -> [MedicalCondition] {
        let dtos = try await service.getAllMedicalConditions()
        return dtos.map { dto in
            MedicalCondition(
                id: dto.id,
                name: dto.name,
                description: dto.description ?? ""
            )
        }
    }

    func fetchProfileMedicalConditions(profileId: String) async throws -> Set<String> {
        let dtos = try await service.getProfileMedicalConditions(profileId: profileId)
        return Set(dtos.map { $0.medicalConditionId })
    }

    func addMedicalCondition(profileId: String, condition: MedicalCondition) async throws {
        let req = AddMedicalConditionRequestDTO(
            medicalConditionId: condition.id,
            name: condition.name,
            description: condition.description
        )
        try await service.addMedicalCondition(profileId: profileId, request: req)
    }

    func removeMedicalCondition(profileId: String, medicalConditionId: String) async throws {
        try await service.removeMedicalCondition(profileId: profileId, medicalConditionId: medicalConditionId)
    }

    func fetchAllAllergies() async throws -> [Allergy] {
        let dtos = try await service.getAllAllergies()
        return dtos.map { dto in
            let type = AllergyType(rawValue: dto.type.uppercased()) ?? .other
            return Allergy(
                id: dto.id,
                name: dto.name,
                type: type,
                source: dto.source
            )
        }
    }

    func fetchProfileAllergies(profileId: String) async throws -> Set<String> {
        let dtos = try await service.getProfileAllergies(profileId: profileId)
        return Set(dtos.map { $0.allergyId })
    }

    func addAllergy(profileId: String, allergy: Allergy) async throws {
        let req = AddAllergyRequestDTO(
            allergyId: allergy.id,
            name: allergy.name,
            type: allergy.type.rawValue
        )
        try await service.addAllergy(profileId: profileId, request: req)
    }

    func removeAllergy(profileId: String, allergyId: String) async throws {
        try await service.removeAllergy(profileId: profileId, allergyId: allergyId)
    }

    func fetchProfileMedications(profileId: String) async throws -> [PatientMedication] {
        let dtos = try await service.getProfileMedications(profileId: profileId)
        return dtos.map { dto in
            PatientMedication(
                id: dto.medicationId,
                recordId: dto.id,
                name: dto.medicationName ?? ""
            )
        }
    }

    func addMedication(profileId: String, name: String) async throws -> PatientMedication {
        let req = AddMedicationRequestDTO(name: name)
        let dto = try await service.addMedication(profileId: profileId, request: req)
        return PatientMedication(
            id: dto.medicationId,
            recordId: dto.id,
            name: dto.medicationName ?? name
        )
    }

    func removeMedication(profileId: String, medicationId: String) async throws {
        try await service.removeMedication(profileId: profileId, medicationId: medicationId)
    }

 

    func fetchEmergencyContact(profileId: String) async throws -> EmergencyContact? {
        let dtos = try await service.getEmergencyContacts(profileId: profileId)
        guard let first = dtos.first else { return nil }
        return EmergencyContact(
            id: first.id,
            name: first.contactName,
            phoneNumber: first.phoneNumber,
            relationship: first.relationship
        )
    }

    func saveEmergencyContact(profileId: String, contact: EmergencyContact) async throws {
        let request = EmergencyContactRequestDTO(contactName: contact.name, relationship: contact.relationship, phoneNumber: contact.phoneNumber)
        try await service.saveEmergencyContact(profileId: profileId, request: request)
    }

    func updateEmergencyContact(contactId: String, contact: EmergencyContact) async throws {
        let request = EmergencyContactRequestDTO(contactName: contact.name, relationship: contact.relationship, phoneNumber: contact.phoneNumber)
        try await service.updateEmergencyContact(contactId: contactId, request: request)
    }

        func saveAddress(profileId: String, address: HomeAddress) async throws {
            let request = AddressRequestDTO(
                country: address.country, city: address.city, area: address.area,
                street: address.streetName, buildingNumber: address.building, apartmentNumber: address.apartment,
                latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0
            )
            try await service.saveAddress(profileId: profileId, request: request)
        }
    func createFamilyMemberProfile(_ info: FamilyMemberBasicInfo) async throws -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let request = CreateProfileRequestDTO(
            relationship: info.relationship,
            firstName: info.firstName,
            lastName: info.lastName,
            dateOfBirth: formatter.string(from: info.dateOfBirth),
            gender: info.gender.rawValue
        )
        return try await service.createProfile(request: request)
    }
    func updateAddress(profileId: String, address: HomeAddress) async throws {
        let request = AddressRequestDTO(
            country: address.country, city: address.city, area: address.area,
            street: address.streetName, buildingNumber: address.building, apartmentNumber: address.apartment,
            latitude: address.latitude ?? 0.0, longitude: address.longitude ?? 0.0
        )
        try await service.updateAddress(profileId: profileId, request: request)
    }

    func fetchAddress(profileId: String) async throws -> HomeAddress? {
        guard let dto = try await service.fetchAddress(profileId: profileId) else {
            return nil
        }
        return HomeAddress(
            country: dto.country,
            city: dto.city,
            area: dto.area,
            streetName: dto.street,
            building: dto.buildingNumber,
            apartment: dto.apartmentNumber,
            latitude: dto.latitude,
            longitude: dto.longitude
        )
    }
}

// MARK: - Errors

enum HomeAddressRepositoryError: LocalizedError {
    case reverseGeocodeFailed
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .reverseGeocodeFailed:
            return "Couldn't determine an address for this location."
        case .locationUnavailable:
            return "Unable to retrieve your current location. Please check your location settings."
        }
    }
}
