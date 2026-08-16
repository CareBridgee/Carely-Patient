//
//  ServiceDetailsViewModel.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import Combine

enum ServiceDetailsSource {
    case services
    case home
}

@MainActor
final class ServiceDetailsViewModel: ObservableObject {
 
    let serviceId: String
 
    @Published var detail: ServiceDetail? = nil
    @Published var isLoading: Bool = false

    /// Drives the full-page `ErrorStateView` when the details fetch fails
    /// (i.e. we have nothing to show yet).
    @Published var loadError: Error? = nil

    /// Drives the floating `.errorToast` for booking failures once details
    /// are already on screen.
    @Published var errorMessage: String? = nil
 
    @Published var isBooking: Bool = false
    @Published var bookingConfirmed: Bool = false
    private var source : ServiceDetailsSource
    private var coordinator: ServicesCoordinator
    private let getServiceDetailUseCase: GetServiceDetailUseCaseProtocol
 
    init(
        serviceId: String,
        getServiceDetailUseCase: GetServiceDetailUseCaseProtocol,
        source: ServiceDetailsSource,
        coordinator: ServicesCoordinator
        
    ) {
        self.serviceId = serviceId
        self.getServiceDetailUseCase = getServiceDetailUseCase
        self.source = source
        self.coordinator = coordinator
    }
 
    func onAppear() {
        guard detail == nil else { return }
        loadDetail()
    }
 
    func loadDetail() {
        isLoading = true
        loadError = nil
 
        Task {
            do {
                let fetched = try await self.getServiceDetailUseCase.execute(id: self.serviceId)
                self.detail = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.loadError = error
            }
        }
    }

    func bookServiceTapped() {
        isBooking = true
        errorMessage = nil
        Task {
            do {
                // TODO: replace with the real booking use case once available;
                // any thrown NetworkError.server(_, message:) will surface its
                // exact server string via the toast below.
                try await Task.sleep(nanoseconds: 800_000_000)
                self.isBooking = false
                coordinator.push(to: .requestService(entryPoint: .manual, preselectedServiceId: serviceId))
            } catch {
                self.isBooking = false
                self.errorMessage = error.carelyDescription
            }
        }
    }
 
    func backTapped() {
        switch source {
        case .services:
            coordinator.pop()

        case .home:
            coordinator.onBackTabbed()
        }
    }
}
