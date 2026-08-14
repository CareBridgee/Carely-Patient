//
//  HistoryCoordinatorView.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct HistoryCoordinatorView: View {
 
    let container: DIContainer
    @ObservedObject var coordinator: HistoryCoordinator
 
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HistoryView(viewModel: container.makeHistoryViewModel(coordinator: coordinator))
                .navigationDestination(for: HistoryRoute.self) { route in
                    destination(for: route)
                }
        }
    }
 
    @ViewBuilder
    private func destination(for route: HistoryRoute) -> some View {
        switch route {
        case .visitDetail(let id):
            VisitDetailView(
                viewModel: container.makeVisitDetailViewModel(visitId: id),
                onBackTapped: { coordinator.pop() }
            )
        }
    }
}
 
