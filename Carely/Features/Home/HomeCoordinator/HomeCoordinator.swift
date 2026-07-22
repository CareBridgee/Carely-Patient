//
//  HomeCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation


@MainActor
final class HomeCoordinator: ObservableObject {

    // MARK: - Cross-Tab Callbacks

    var onViewAllServices: (() -> Void)?
    var onOpenService: (() -> Void)?
    var onOpenActiveVisit: (() -> Void)?
    var onOpenAIAssistant: (() -> Void)?

    // MARK: - Actions

    func viewAllServicesTapped() {
        onViewAllServices?()
    }

    func serviceTapped() { // will inject service here
        onOpenService?()
    }

    func activeVisitTapped() { // will inject visit here
        onOpenActiveVisit?()
    }

    func aiBannerTapped() {
        onOpenAIAssistant?()
    }
}
