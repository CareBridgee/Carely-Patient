import Foundation

struct PersonalInfoRequestDTO: Encodable {
    let firstName: String
    let lastName: String
    let dateOfBirth: String // YYYY-MM-DD
    let gender: String
}