//
//  HistoryRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
final class HistoryRepositoryImpl: HistoryRepositoryProtocol {
    private let historyService: HistoryServiceProtocol
 
    init(historyService: HistoryServiceProtocol) {
        self.historyService = historyService
    }
 
    func fetchHistory() async throws -> [VisitHistoryItem] {
        let dtos = try await historyService.getConfirmedRequests()
        return dtos.map(Self.map)
    }
 
    func fetchVisitDetail(id: String) async throws -> VisitDetail {
        let dto = try await historyService.getRequestDetail(id: id)
        return Self.map(dto)
    }
 
    // MARK: - Mapping
 
    private static func map(_ dto: ServiceRequestHistoryDTO) -> VisitHistoryItem {
        VisitHistoryItem(
            id: dto.serviceRequestId,
            nurseName: nurseDisplayName(dto.nurse),
            nurseImageUrl: dto.nurse?.profileImageUrl,
            serviceName: dto.serviceName ?? "Service",
            status: VisitStatus(rawStatus: dto.status),
            dateText: dto.preferredDate ?? "",
            timeText: dto.preferredTime?.displayText ?? ""
        )
    }
 
    private static func map(_ dto: ServiceRequestDetailDTO) -> VisitDetail {
        VisitDetail(
            id: dto.serviceRequestId,
            serviceName: dto.serviceType?.name ?? "Service",
            status: VisitStatus(rawStatus: dto.status),
            dateText: dto.preferredDate ?? "",
            timeText: dto.preferredTime?.displayText ?? "",
            nurseName: nurseDisplayName(dto.nurse),
            nurseImageUrl: dto.nurse?.profileImageUrl,
            nurseTitle: "Professional Nurse",
            description: dto.serviceDescription
        )
    }
 
    private static func nurseDisplayName(_ nurse: NurseDetailsDTO?) -> String {
        guard let nurse else { return "Care Provider" }
        let name = [nurse.firstName, nurse.lastName]
            .compactMap { $0 }
            .joined(separator: " ")
            .trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? "Care Provider" : name
    }
}
 
