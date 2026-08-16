//
//  PendingRefund.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

struct PendingRefund: Codable {
    let requestId: String
    let amount: Double
}

final class PendingRefundManager {
    static let shared = PendingRefundManager()
    private let defaults = UserDefaults.standard
    private let key = "PendingRefundsList"
    
    private init() {}
    
    func savePendingRefund(requestId: String, amount: Double) {
        var refunds = getAllPendingRefunds()
        if let index = refunds.firstIndex(where: { $0.requestId == requestId }) {
            let newAmount = refunds[index].amount + amount
            refunds[index] = PendingRefund(requestId: requestId, amount: newAmount)
        } else {
            refunds.append(PendingRefund(requestId: requestId, amount: amount))
        }
        save(refunds)
    }
    
    func getAllPendingRefunds() -> [PendingRefund] {
        guard let data = defaults.data(forKey: key),
              let refunds = try? JSONDecoder().decode([PendingRefund].self, from: data) else {
            return []
        }
        return refunds
    }
    
    func removeRefund(requestId: String) {
        var refunds = getAllPendingRefunds()
        refunds.removeAll { $0.requestId == requestId }
        save(refunds)
    }
    
    private func save(_ refunds: [PendingRefund]) {
        if let data = try? JSONEncoder().encode(refunds) {
            defaults.set(data, forKey: key)
        }
    }
}