//
//  AuthRoute.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case Welcome // choose phone or email
    case PhoneNumber
    case OTPVerification(phoneNumber:String) // Failure , Success + check if it was a new user
    case PersonalInfo
    case ProfileSetupDecision
}
