//
//  HomeCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation
import SwiftUI
 
@MainActor
final class HomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
 
    // MARK: - Cross-Tab Callbacks
 
    var onViewAllServices: (() -> Void)?
    var onOpenService: ((String) -> Void)?
    var onOpenActiveVisit: ((ConfirmedOffer) -> Void)?
    var onOpenAIAssistant: (() -> Void)?
    var onOpenHistory: (() -> Void)?
 
    // MARK: - Actions
 
    func viewAllServicesTapped() {
        onViewAllServices?()
    }
 
    func seeAllHistoryTapped() {
        onOpenHistory?()
    }
 
    func serviceTapped(serviceId: String) {
        onOpenService?(serviceId)
    }
 
    func activeVisitTapped(offer: ConfirmedOffer) {
        onOpenActiveVisit?(offer)
    }
 
    func aiBannerTapped() {
        onOpenAIAssistant?()
    }
}
 
