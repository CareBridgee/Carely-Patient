//
//  AIPatient.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation

struct AIPatient: Identifiable, Equatable {
    let id: String
    let name: String
    let relation: String
    let isSelf: Bool
    let imageUrl: String?
}
