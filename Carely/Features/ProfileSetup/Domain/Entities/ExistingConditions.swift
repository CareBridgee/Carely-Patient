//
//  ExistingConditions.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

struct ExistingConditions: Equatable {
    var availableConditions: [MedicalCondition] = []
    var selectedConditionIds: Set<String> = []
}
