//
//  UserDTO.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation

struct UserDTO: Decodable {
    let id: String
    let phoneNumber: String
    let email: String?
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let gender: Gender?
    let profileImageUrl: String?
    let isDeleted: Bool
    let createdAt: Date
    let updatedAt: Date
    let lastLoginAt: Date?
    let defaultProfileId: String?
}
