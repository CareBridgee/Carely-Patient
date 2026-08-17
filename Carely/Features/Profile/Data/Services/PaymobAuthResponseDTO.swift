//
//  PaymobAuthResponseDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

struct PaymobAuthResponseDTO: Decodable {
    let token: String
}

struct PaymobOrderResponseDTO: Decodable {
    let id: Int
}

struct PaymobPaymentKeyResponseDTO: Decodable {
    let token: String
}

struct PaymobBillingData: Encodable {
    var apartment = "NA"
    var email = "NA"
    var floor = "NA"
    var firstName = "NA"
    var street = "NA"
    var building = "NA"
    var phoneNumber = "NA"
    var shippingMethod = "NA"
    var postalCode = "NA"
    var city = "NA"
    var country = "NA"
    var lastName = "NA"
    var state = "NA"

    enum CodingKeys: String, CodingKey {
        case apartment, email, floor
        case firstName = "first_name"
        case street, building
        case phoneNumber = "phone_number"
        case shippingMethod = "shipping_method"
        case postalCode = "postal_code"
        case city, country
        case lastName = "last_name"
        case state
    }
}
