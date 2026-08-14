//
//  User.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 30/07/2026.
//


//
//  User.swift
//  Carely
//

import Foundation

struct User: Codable, Equatable {
    let id: String
    let phoneNumber: String
    var email: String?
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var gender: String? 
    var profileImageUrl: String?
    let isDeleted: Bool
    let createdAt: Date
    let updatedAt: Date
    let lastLoginAt: Date?
    var defaultProfileId: String?
    
    var isProfileIncomplete: Bool {
        return firstName == nil || firstName == "User" || lastName == nil || lastName?.isEmpty == true
    }
}