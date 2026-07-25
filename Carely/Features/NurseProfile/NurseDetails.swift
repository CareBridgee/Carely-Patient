//
//  NurseDetails.swift
//  Carely
//
//  Created by Mona Zarea on 23/07/2026.
//

import Foundation
struct NurseDetails: Equatable {
    let id: String
    let fullName: String
    let title: String
    let specialty: String
    let profileImageUrl: String
    let rating: Double
    let reviewsCount: Int
    let experienceYears: Int
    let providedServices: [String]
    let certificates: [Certificate]
    let personalApproach: String
    
    struct Certificate: Equatable, Identifiable {
        let id = UUID()
        let name: String
        let imageUrl: String
    }
}
