//
//  NurseOffer.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
struct NurseOffer: Identifiable, Equatable {
    let id: String
    let name: String
    let title: String
    let price: Double
    let rating: Double
    let reviewsCount: Int
    let distance: Double
    let imageLink: String
}
