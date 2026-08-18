//
//  ProfileRoute.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation

enum ProfileRoute: Hashable {
    case familyMembers
    case settings
    case personalInfo(profileId: String)
    case healthProfile(profileId: String)
    case editMemberPersonalInfo(profileId: String)
    case editMemberHealthProfile(profileId: String)
    case address(profileId: String)
    case wallet
    case topUp(userId: String)
    case addFamilyMember
}
