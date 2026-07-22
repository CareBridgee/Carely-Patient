//
//  ServiceDetail.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
struct ServiceDetail: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String
    let badgeText: String
    let heroIconName: String
    let priceText: String
    let durationText: String
    let aboutDescription: String
    let includedItems: [String]
    let noteText: String
}
