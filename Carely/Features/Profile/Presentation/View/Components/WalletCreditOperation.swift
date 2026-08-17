//
//  WalletCreditOperation.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation
 
enum WalletCreditOperation: String {
    case add = "ADD"
    case deduct = "DEDUCT"
}
 
enum WalletError: LocalizedError {
    case invalidAmount
    case insufficientCredit
    case missingUserId
 
    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Please enter a valid amount."
        case .insufficientCredit:
            return "Insufficient credit. Please add more credit or choose Cash as your payment method."
        case .missingUserId:
            return "Could not identify your account. Please try again."
        }
    }
}
 
struct PaymobIntention {
    let clientSecret: String
}