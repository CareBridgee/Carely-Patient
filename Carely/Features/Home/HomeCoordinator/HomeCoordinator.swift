//
//  HomeCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation
import SwiftUI
 
@MainActor
final class HomeCoordinator: AppRouterProtocol {
    typealias Route = HomeRoute
    @Published var path = NavigationPath()
 
    // MARK: - Cross-Tab Callbacks
 
    var onViewAllServices: (() -> Void)?
    var onOpenService: ((String) -> Void)?
    var onOpenActiveVisit: ((ConfirmedOffer) -> Void)?
    var onOpenHistory: (() -> Void)?
    var onOpenProfile: (() -> Void)?
    var onRequestServiceFromAI: ((ReservationDraft?, String?) -> Void)?
    var onBackClicked: (() -> Void)?
 
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
        push(to: .choosePatient)
    }
    
    func requestServiceFromAITapped(draft: ReservationDraft? = nil, profileId: String? = nil) {
        onRequestServiceFromAI?(draft, profileId)
    }

    func profileTapped() {
        onOpenProfile?()
    }
}
 
