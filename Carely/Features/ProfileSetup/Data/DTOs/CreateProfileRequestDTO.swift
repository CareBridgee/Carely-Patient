//
//  CreateProfileRequestDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

struct CreateProfileRequestDTO: Encodable {
    let relationship: String
    let firstName: String
    let lastName: String
    let dateOfBirth: String
    let gender: String
}

struct CreateProfileResponseDTO: Decodable {
    let id: String
}