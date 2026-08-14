import Foundation
import Combine

/// A pure in-memory, main-actor observable state store for Patient Profiles.
/// Serves as the single source of truth for the shared profile data across the app.
/// This store does not perform any networking or hold any API dependencies.
@MainActor
final class PatientProfilesStore: ObservableObject {
    @Published private(set) var primaryProfile: PatientProfile?
    @Published private(set) var familyMembers: [FamilyMember] = []
    @Published private(set) var addressesByProfileId: [String: HomeAddress] = [:]

    init() {}

    // MARK: - Primary Profile
    func setPrimaryProfile(_ profile: PatientProfile) {
        self.primaryProfile = profile
    }

    // MARK: - Family Members
    func setFamilyMembers(_ members: [FamilyMember]) {
        self.familyMembers = members
    }

    func addFamilyMember(_ member: FamilyMember) {
        if !familyMembers.contains(where: { $0.id == member.id }) {
            familyMembers.append(member)
        } else {
            updateFamilyMember(member)
        }
    }

    func updateFamilyMember(_ member: FamilyMember) {
        if let index = familyMembers.firstIndex(where: { $0.id == member.id }) {
            familyMembers[index] = member
        } else {
            familyMembers.append(member)
        }
    }

    func removeFamilyMember(id: String) {
        familyMembers.removeAll { $0.id == id }
        // Also remove address if we store it
        addressesByProfileId.removeValue(forKey: id)
    }

    // MARK: - Addresses
    func updateAddress(profileId: String, address: HomeAddress) {
        addressesByProfileId[profileId] = address
    }
}
