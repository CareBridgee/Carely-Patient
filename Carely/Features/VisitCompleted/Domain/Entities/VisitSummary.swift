//
//  VisitSummary.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
struct VisitSummary: Identifiable, Equatable {
    let id: String
    let isVerified: Bool
    let medicalProfessionalName: String
    let serviceType: String
    let visitDurationText: String
    let completedDateText: String
    let totalAmountText: String
}
