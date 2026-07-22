//
//  ServiceDetailsViewModel.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import Combine
 
@MainActor
final class ServiceDetailsViewModel: ObservableObject {
 
    let serviceId: String
 
    @Published var detail: ServiceDetail? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
    @Published var isBooking: Bool = false
    @Published var bookingConfirmed: Bool = false
 
    private let getServiceDetailUseCase: GetServiceDetailUseCaseProtocol
 
    init(
        serviceId: String,
        getServiceDetailUseCase: GetServiceDetailUseCaseProtocol
    ) {
        self.serviceId = serviceId
        self.getServiceDetailUseCase = getServiceDetailUseCase
    }
 
    func onAppear() {
        guard detail == nil else { return }
        loadDetail()
    }
 
    func loadDetail() {
        isLoading = true
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await getServiceDetailUseCase.execute(id: serviceId)
                self.detail = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }

    func bookServiceTapped() {
        isBooking = true
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)
            self.isBooking = false
            self.bookingConfirmed = true
        }
    }
 
    func backTapped() {
        // 
    }
}
 
