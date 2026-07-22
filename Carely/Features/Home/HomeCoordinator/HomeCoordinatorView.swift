//
//  HomeCoordinatorView.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import SwiftUI

// MARK: - HomeCoordinatorView

struct HomeCoordinatorView: View {

    let container: DIContainer
    @ObservedObject var coordinator: HomeCoordinator

    var body: some View {
        NavigationStack {
            HomeView(viewModel: container.makeHomeViewModel(onServiceTabbed: coordinator.serviceTapped))
        }
    }
}
