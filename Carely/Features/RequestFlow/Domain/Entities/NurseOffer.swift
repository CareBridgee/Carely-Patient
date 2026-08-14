import Foundation

struct NurseOffer: Identifiable, Equatable {
    let id: String
    let nurseId: String
    let name: String
    let title: String
    let price: Double
    let rating: Double
    let reviewsCount: Int
    let distance: Double
    let imageLink: String
    let specialty: String
    let estimatedArrival: String
}
