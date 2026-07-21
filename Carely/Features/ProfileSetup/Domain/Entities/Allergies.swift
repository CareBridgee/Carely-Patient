//
//  Allergies.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

struct Allergies {
    var hasNoKnownAllergies: Bool = false
    var drugAllergies: Set<String> = []
    var foodAllergies: Set<String> = []
    var otherAllergiesNote: String = ""
}
