//
//  AuthError.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//
import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidOTP
    case otpExpired
    case network
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidOTP:
            return "The code you entered is incorrect. Please try again."
        case .otpExpired:
            return "This code has expired. Please request a new one."
        case .network:
            return "Something went wrong. Please check your connection and try again."
        case .unknown:
            return "Something went wrong. Please try again."
        }
    }
}
