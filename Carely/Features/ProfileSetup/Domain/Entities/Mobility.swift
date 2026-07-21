//
//  Mobility.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation


enum MobilityStatus: CaseIterable, Hashable {
    case independent
    case needsAssistance
    case usesWalkingAid
    case wheelchairUser
    case bedridden

    var title: String {
        switch self {
        case .independent: return "Independent"
        case .needsAssistance: return "Needs Assistance"
        case .usesWalkingAid: return "Uses Walking Aid"
        case .wheelchairUser: return "Wheelchair User"
        case .bedridden: return "Bedridden"
        }
    }

    var subtitle: String {
        switch self {
        case .independent: return "Moves freely without any assistance"
        case .needsAssistance: return "Requires a person's physical help"
        case .usesWalkingAid: return "Cane, walker or crutches"
        case .wheelchairUser: return "Relies on manual or electric wheelchair"
        case .bedridden: return "Confined to bed for most of the day"
        }
    }

    var icon: String {
        switch self {
        case .independent: return "figure.walk"
        case .needsAssistance: return "figure.2.arms.open"
        case .usesWalkingAid: return "figure.walk.motion"
        case .wheelchairUser: return "figure.roll"
        case .bedridden: return "bed.double.fill"
        }
    }
}

struct Mobility {
    var status: MobilityStatus? = nil
    var additionalNotes = ""
}
