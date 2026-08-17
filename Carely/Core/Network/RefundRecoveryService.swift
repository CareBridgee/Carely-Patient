//
//  RefundRecoveryService.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

final class RefundRecoveryService {
    static var shared: RefundRecoveryService? // 👈 Shared instance for global triggers
    
    private let walletService: WalletServiceProtocol
    private let historyService: HistoryServiceProtocol
    private var isProcessing = false

    init(walletService: WalletServiceProtocol, historyService: HistoryServiceProtocol) {
        self.walletService = walletService
        self.historyService = historyService
        RefundRecoveryService.shared = self
    }

    func processPendingRefunds() async {
        guard !isProcessing else { return }
        let pendingRefunds = PendingRefundManager.shared.getAllPendingRefunds()
        guard !pendingRefunds.isEmpty else { return }
        
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let userId = try await walletService.getCurrentUserId()
            
            for refund in pendingRefunds {
                do {
                    let requestDetail = try await historyService.getRequestDetail(id: refund.requestId)
                    let status = requestDetail.status?.uppercased() ?? ""
                    
                    if status == "CANCELLED" || status == "REJECTED" {
                        _ = try await walletService.updateCredit(
                            userId: userId,
                            amount: refund.amount,
                            operation: "ADD"
                        )
                        PendingRefundManager.shared.removeRefund(requestId: refund.requestId)
                        print("💰 Global Recovery Refund successful for \(refund.requestId)")
                        
                    } else if status == "COMPLETED" {
                        PendingRefundManager.shared.removeRefund(requestId: refund.requestId)
                        print("✅ Visit completed. Receipt removed without refund.")
                    }
                } catch {
                    print("⚠️ Failed to check status for \(refund.requestId): \(error)")
                }
            }
        } catch {
            print("❌ Failed to get user ID for recovery: \(error)")
        }
    }
}
