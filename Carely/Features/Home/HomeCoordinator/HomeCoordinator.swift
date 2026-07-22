//
//  HomeCoordinator.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import SwiftUI
 
struct HomeCoordinator: View {
    let container: DIContainer
    let appState: AppState
 
    @StateObject private var router = HomeRouter()
 
    var body: some View {
        NavigationStack(path: $router.path) {
            HomeView(viewModel: container.makeHomeViewModel(router: router))
                .navigationDestination(for: HomeRoute.self) { route in
                    destination(for: route)
                }
        }
    }
 
    @ViewBuilder
    private func destination(for route: HomeRoute) -> some View {
        switch route {
 
        case .serviceCategories:
            ServiceCategoriesView(
                viewModel: container.makeServiceCategoriesViewModel(router: router)
            )
 
        case .serviceDetails(let serviceId):
            ServiceDetailsView(
                viewModel: container.makeServiceDetailsViewModel(
                    serviceId: serviceId,
                    router: router
                )
            )
        }
    }
}
 
