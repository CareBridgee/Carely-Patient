//
//  AIAssistantCoordinator.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import Foundation
import SwiftUI
@MainActor
final class AIAssistantCoordinator: AppRouterProtocol{
    typealias Route = AIAssistantRoute
    @Published var path = NavigationPath()

    var onBackClicked: (() -> Void)?
    

    var onRequestNow: ((ReservationDraft?, String?) -> Void)?
    var onAddFamilyMember: (() -> Void)?
    var onViewProfiledetails: ((String) -> Void)?
    var onViewAllServices: (() -> Void)?
    
    
    func requestNowTapped(draft: ReservationDraft? = nil, profileId: String? = nil) {
        onRequestNow?(draft, profileId)
    }
    
    func addFamilyMemberTapped() {
        onAddFamilyMember?()
    }
    
    func viewProfiledetailsTapped(profileId: String) {
        onViewProfiledetails?(profileId)
    }
    
    func viewAllServicesTapped() {
        onViewAllServices?()
    }
    
}
