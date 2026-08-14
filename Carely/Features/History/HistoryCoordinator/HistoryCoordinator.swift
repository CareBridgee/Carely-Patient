//
//  HistoryCoordinator.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
import SwiftUI
 
@MainActor
final class HistoryCoordinator: AppRouterProtocol {
    typealias Route = HistoryRoute
 
    @Published var path = NavigationPath()
    var onBackClicked: (() -> Void)?
 
    /// Cross-tab: "Explore Services" on the empty-history state.
    var onExploreServices: (() -> Void)?
 
    func openVisitDetail(id: String) {
        push(to: .visitDetail(id: id))
    }
 
    func exploreServicesTapped() {
        onExploreServices?()
    }
}
