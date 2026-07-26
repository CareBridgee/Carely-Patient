//
//  DevOTPResponse.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation

struct DevOTPResponse: Decodable {
    let phoneNumber: String
    let otp: String
}
