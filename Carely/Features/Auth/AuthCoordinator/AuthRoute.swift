//
//  AuthRoute.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case PhoneNumber
    case OTPVerification(phoneNumber:String) // Failure , Success + check if it was a new user
    case PersonalInfo
}
