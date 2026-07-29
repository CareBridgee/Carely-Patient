// UserUpdateRequestDTO.swift
import Foundation

struct UserUpdateRequestDTO: Encodable {
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let gender: String
    let profileImageUrl: String?

    private enum CodingKeys: String, CodingKey {
        case firstName, lastName, dateOfBirth, gender, profileImageUrl
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(firstName, forKey: .firstName)
        try c.encode(lastName, forKey: .lastName)
        try c.encode(dateOfBirth, forKey: .dateOfBirth)
        try c.encode(gender, forKey: .gender)
        if let profileImageUrl { try c.encode(profileImageUrl, forKey: .profileImageUrl) }
    }
}