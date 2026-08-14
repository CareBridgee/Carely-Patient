//
//  AuthRoute.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case PhoneNumber(pendingToken: String?)
    case OTPVerification(phoneNumber: String, devOTP: String?, pendingToken: String?)
    case PersonalInfo
}
