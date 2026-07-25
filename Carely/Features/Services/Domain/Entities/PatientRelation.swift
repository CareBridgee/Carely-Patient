//
//  PatientRelation.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import Foundation

enum PatientRelation: String, CaseIterable, Identifiable {
    case self_ = "Self"
    case father = "Father"
    case mother = "Mother"

    var id: Self { self }
    var title: String { rawValue }
}

struct CareService: Identifiable, Equatable {
    let id: String
    let title: String
    let icon: String
}

struct PatientAddress: Equatable {
    var line1: String
    var line2: String
    var district: String
}

enum PaymentMethod: String, CaseIterable, Identifiable {
    case cashOnDelivery
    case wallet

    var id: Self { self }

    var title: String {
        switch self {
        case .cashOnDelivery: return "Cash on delivery"
        case .wallet: return "Wallet"
        }
    }

    var subtitle: String {
        switch self {
        case .cashOnDelivery: return "Est. arrival: 2-3 business days"
        case .wallet: return "Est. arrival: Within 24 hours"
        }
    }

    var icon: String {
        switch self {
        case .cashOnDelivery: return "banknote.fill"
        case .wallet: return "wallet.pass.fill"
        }
    }
}

struct CareRequest {
    var patient: PatientRelation
    var service: CareService
    var description: String
    var address: PatientAddress?
    var paymentMethod: PaymentMethod
}