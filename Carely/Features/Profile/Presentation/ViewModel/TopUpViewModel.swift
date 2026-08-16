//
//  TopUpViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation
import Combine

@MainActor
final class TopUpViewModel: ObservableObject {

    @Published var amountString: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showPaymobSheet: Bool = false
    @Published var checkoutURL: URL? = nil

    let userId: String
    var onTopUpSuccess: ((Double) -> Void)?

    private let getCheckoutURLUseCase: GetPaymobCheckoutURLUseCaseProtocol
    private let addWalletCreditUseCase: AddWalletCreditUseCaseProtocol
    private var didHandlePaymentResult = false

    var isContinueEnabled: Bool {
        guard let amount = Double(amountString), amount > 0 else { return false }
        return true
    }

    var amountValue: Double { Double(amountString) ?? 0 }

    init(
        userId: String,
        getCheckoutURLUseCase: GetPaymobCheckoutURLUseCaseProtocol,
        addWalletCreditUseCase: AddWalletCreditUseCaseProtocol
    ) {
        self.userId = userId
        self.getCheckoutURLUseCase = getCheckoutURLUseCase
        self.addWalletCreditUseCase = addWalletCreditUseCase
    }

    /// Step 1: build the Paymob checkout URL directly (auth -> order ->
    /// payment_key), then present it in the bottom sheet.
    func startTopUpFlow() {
        guard isContinueEnabled else { return }
        isLoading = true
        errorMessage = nil
        didHandlePaymentResult = false

        Task {
            do {
                checkoutURL = try await getCheckoutURLUseCase.execute(amount: amountValue)
                isLoading = false
                showPaymobSheet = true
            } catch {
                isLoading = false
                errorMessage = error.carelyDescription
            }
        }
    }

    /// Step 2: Paymob's redirect reported success. Only now do we call the
    /// credit endpoint — never deduct/add just because a flow started.
    func handlePaymobSuccess() {
        didHandlePaymentResult = true
        showPaymobSheet = false
        submitTopUpToBackend()
    }

    func handlePaymobRejected(message: String) {
        didHandlePaymentResult = true
        showPaymobSheet = false
        errorMessage = message
    }

    /// Called if the user closes the sheet (swipe-down) before any
    /// success/failure redirect happened — treated as a silent cancel,
    /// not an error.
    func sheetDismissedByUser() {
        guard !didHandlePaymentResult else { return }
        didHandlePaymentResult = true
        showPaymobSheet = false
    }

    private func submitTopUpToBackend() {
        let amount = amountValue
        guard amount > 0 else { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let newBalance = try await addWalletCreditUseCase.execute(userId: userId, amount: amount)
                self.isLoading = false
                self.onTopUpSuccess?(newBalance)
            } catch {
                self.isLoading = false
                self.errorMessage = error.carelyDescription
            }
        }
    }
}
