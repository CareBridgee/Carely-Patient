//
//  ActiveVisitStore.swift
//  Carely
//
//  Created by Mona Zarea on 15/08/2026.
//

import Foundation
import Combine

@MainActor
final class ActiveVisitStore: ObservableObject {
    @Published private(set) var activeVisit: ConfirmedOffer? = nil
    
    var hasActiveVisit: Bool {
        activeVisit != nil
    }

    func setActiveVisit(_ offer: ConfirmedOffer?) {
        self.activeVisit = offer
    }

    func clearActiveVisit() {
        self.activeVisit = nil
    }
}

