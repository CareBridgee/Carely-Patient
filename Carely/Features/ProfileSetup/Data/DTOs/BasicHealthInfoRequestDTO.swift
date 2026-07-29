import Foundation

struct BasicHealthInfoRequestDTO: Encodable {
    let bloodType: String
    let height: Double?
    let weight: Double?
}

struct MedicalHistoryRequestDTO: Encodable {
    let previousSurgeries: String
    let previousHospitalizations: String
}

struct EmergencyContactRequestDTO: Encodable {
    let firstName: String
    let phoneNumber: String
    let relationship: String
}

struct AddressRequestDTO: Encodable {
    let country: String
    let city: String
    let area: String
    let street: String
    let buildingNumber: String
    let apartmentNumber: String
    let latitude: Double
    let longitude: Double
}