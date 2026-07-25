//
//  FamilyMember.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

struct FamilyMember: Identifiable, Equatable {
    let id: String
    let name: String
    let relation: String
    let avatarIconName: String
    let lastCheckupDateText: String
    let upcomingCareText: String
}
