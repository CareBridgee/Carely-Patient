//
//  OTPVerificationEntity.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import Foundation

struct OTPVerificationEntity: Equatable {
    let isNewUser: Bool
    let accessToken: String
    let refreshToken: String?
    let userId: String
}

