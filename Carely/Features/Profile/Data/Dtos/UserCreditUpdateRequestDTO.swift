//
//  UserCreditUpdateRequestDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


struct UserCreditUpdateRequestDTO: Encodable {
    let amount: Double
    let operation: String // "ADD" or "DEDUCT"
}

struct UserCreditUpdateResponseDTO: Decodable {
    let credit: Double
}