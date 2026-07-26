//
//  ProfileRepositoryImpl.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

final class ProfileRepositoryImpl: ProfileRepositoryProtocol {

    private let simulatedDelayNanoseconds: UInt64 = 500_000_000

    init() {}

    func fetchPatientProfile() async throws -> PatientProfile {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return PatientProfile(
            name: "Elena Rodriguez",
            role: "Primary Caregiver",
            avatarIconName: "person.fill",
            appVersionText: "Serene Care v2.4.1"
        )
    }

    func fetchFamilyMembers() async throws -> [FamilyMember] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)
        return [
            FamilyMember(
                id: "member-maria",
                name: "Maria Garcia",
                relation: "Mother",
                avatarIconName: "person.crop.circle.fill",
                lastCheckupDateText: "Oct 12, 2023",
                upcomingCareText: "Dental Care"
            ),
            FamilyMember(
                id: "member-roberto",
                name: "Roberto Garcia",
                relation: "Father",
                avatarIconName: "person.crop.circle.fill",
                lastCheckupDateText: "Sept 28, 2023",
                upcomingCareText: "Blood Work"
            ),
            FamilyMember(
                id: "member-sofia",
                name: "Sofia Garcia",
                relation: "Daughter",
                avatarIconName: "person.crop.circle.fill",
                lastCheckupDateText: "Nov 05, 2023",
                upcomingCareText: "Vaccination"
            )
        ]
    }
}
