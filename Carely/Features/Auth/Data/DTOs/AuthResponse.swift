//
//  AuthResponse.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation

struct AuthResponse: Decodable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int64
    let user: UserDTO
}
