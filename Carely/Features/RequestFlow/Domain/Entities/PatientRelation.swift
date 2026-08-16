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
    case cash
    case wallet

    var id: Self { self }

    var title: String {
        switch self {
        case .cash: return "Cash" 
        case .wallet: return "Wallet"
        }
    }

    var backendValue: String {
        switch self {
        case .cash: return "CASH"
        case .wallet: return "CREDIT"
        }
    }

    var icon: String {
            switch self {
            case .cash: return "banknote"
            case .wallet: return "wallet.bifold"
            }
    }
}

struct CareRequest {
    var patient: ServiceRequestPatient
    var service: CareService
    var description: String
    var address: ServiceRequestAddress?
    var paymentMethod: String
}
