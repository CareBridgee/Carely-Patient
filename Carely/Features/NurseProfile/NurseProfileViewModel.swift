import Foundation
import SwiftUI



@MainActor
final class NurseProfileViewModel: ObservableObject {
    @Published var profile: NurseDetails?
    @Published var isLoading = true
    
    private let nurseId: String
    
    init(nurseId: String) {
        self.nurseId = nurseId
    }
    
    func fetchProfile() {
        isLoading = true
        // Mocking network delay
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            self.profile = NurseDetails(
                id: nurseId,
                fullName: "Sarah Mitchell",
                title: "RN",
                specialty: "Specialized Geriatric Care Practitioner",
                profileImageUrl: "mock_nurse_image",
                rating: 4.9,
                reviewsCount: 124,
                experienceYears: 12,
                providedServices: ["Wound Care", "Medication Mgmt", "Post-Op Recovery", "IV Therapy", "Vitals Monitoring"],
                certificates: [
                    .init(name: "ACLS Certification", imageUrl: "cert_mock_1"),
                    .init(name: "ACLS Certification", imageUrl: "cert_mock_2")
                ],
                personalApproach: "\"I believe in providing care that respects the dignity and independence of every patient. With over 12 years in hospitals and home care, I focus on clear communication with both patients and their families to ensure a smooth recovery process.\""
            )
            self.isLoading = false
        }
    }
}
