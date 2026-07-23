import Foundation

struct ConfirmedOffer: Identifiable, Equatable, Hashable {
    let id: String
    let status: String
    let estimatedArrival: String
    let distanceKm: Double
    let qrCodeData: String
    let cancellationDeadline: String
    let nurse: NurseDetails
    let contact: ContactDetails
    
    struct NurseDetails: Equatable, Hashable {
        let id: String
        let fullName: String
        let title: String
        let specialty: String
        let profileImageUrl: String
        let rating: Double
        let reviewsCount: Int
    }
    
    struct ContactDetails: Equatable, Hashable {
        let phoneNumber: String
        let chatChannelId: String
    }
}
