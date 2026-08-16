//
//  CareRequestRepositoryImpl.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//

final class CareRequestRepositoryImpl: CareRequestRepositoryProtocol {
    private let serviceTypeService: ServiceTypeServiceProtocol
    private let serviceRequestService: ServiceRequestServiceProtocol

    init(
        serviceTypeService: ServiceTypeServiceProtocol,
        serviceRequestService: ServiceRequestServiceProtocol
    ) {
        self.serviceTypeService = serviceTypeService
        self.serviceRequestService = serviceRequestService
    }

    func fetchAvailableServices() async throws -> [CareService] {
        let serviceTypes = try await serviceTypeService.getServiceTypes()
        return serviceTypes.map { CareService(serviceType: $0) }
    }

    func fetchPatients() async throws -> [ServiceRequestPatient] {
        let profiles = try await serviceRequestService.getProfiles()
        return profiles
            .filter { !$0.isDeleted }
            .map {
                ServiceRequestPatient(
                    id: $0.id, firstName: $0.firstName, lastName: $0.lastName,
                    relationship: $0.relationship ?? "self", isPrimary: $0.isPrimary
                )
            }
    }

    func fetchAddress(profileId: String) async throws -> ServiceRequestAddress? {
        do {
            let dto = try await serviceRequestService.getAddress(profileId: profileId)
            return ServiceRequestAddress(
                id: dto.id, profileId: dto.profileId, country: dto.country, city: dto.city,
                area: dto.area, street: dto.street, buildingNumber: dto.buildingNumber,
                apartmentNumber: dto.apartmentNumber, latitude: dto.latitude, longitude: dto.longitude
            )
        } catch let error as NetworkError {
            if case .server(404, _) = error { return nil }   // no address yet — not an error
            throw error
        }
    }

    func submitCareRequest(_ request: CareRequest) async throws -> ServiceRequestResult {
        guard let address = request.address else {
            throw ServiceRequestValidationError.missingAddress
        }
        let body = ServiceRequestBodyDTO(
            profileId: request.patient.id,
            serviceTypeId: request.service.id,
            latitude: address.latitude,
            longitude: address.longitude,
            serviceDescription: request.description,
            paymentType: request.paymentMethod
        )
        let response = try await serviceRequestService.submitServiceRequest(body)
        return ServiceRequestResult(
            serviceRequestId: response.serviceRequestId, profileId: response.profileId,
            serviceTypeId: response.serviceTypeId, status: response.status,
            latitude: response.latitude, longitude: response.longitude,
            nearbyNurses: response.nearbyNurses.map {
                NearbyNurseInfo(nurseId: $0.nurseId, latitude: $0.latitude, longitude: $0.longitude, distanceKm: $0.distanceKm)
            }
        )
    }
}
