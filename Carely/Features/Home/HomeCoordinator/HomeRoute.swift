//
//  HomeRoute.swift
//  Carely
//
//  Created by Mohamed Ayman on 18/08/2026.
//

import Foundation

enum HomeRoute: Hashable {
    case choosePatient
    case aiChat(patientId: String)
    case addFamilyMember
}
