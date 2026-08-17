//
//  WalletCurrentUserDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


//
//  WalletDTOs.swift
//  Carely
//

import Foundation

/// Deliberately decodes only "id" from GET /users/me. The rest of that
/// response is irrelevant to this feature and is safely ignored by Codable.
struct WalletCurrentUserDTO: Decodable {
    let id: String
}

struct WalletCreditResponseDTO: Decodable {
    let credit: Double
}

struct WalletCreditUpdateResponseDTO: Decodable {
    let credit: Double
}

struct WalletAPIErrorBody: Decodable {
    let status: Int
    let code: String
    let message: String
}

struct WalletCreditUpdateRequestDTO: Encodable {
    let amount: Double
    let operation: String
}
 


struct PaymobIntentionRequestDTO: Encodable {
    let amount: Double
}



