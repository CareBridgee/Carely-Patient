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

struct GoogleAuthResponse: Decodable {
    let status: String
    
    let accessToken: String?
    let refreshToken: String?
    let expiresIn: Int64?
    let user: UserDTO?
    
    let pendingToken: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let profileImageUrl: String?
}
