//
//  PersonalInfoRequestDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//


import Foundation

struct PersonalInfoRequestDTO: Encodable {
    let relationship: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let gender: String

    init(relationship: String = "SELF", firstName: String, lastName: String, dateOfBirth: String, gender: String) {
        self.relationship = relationship
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
}
