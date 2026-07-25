//
//  ServiceCategory.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 

enum ServiceCategoryLayout: Equatable {
    case standard   // 1 column x 1 row
    case featured   // 1 column x 2 rows (tall highlight card)
    case wide       // 2 columns x 1 row
}
 

enum ServiceCategoryAccent: Equatable {
    case primary
    case secondary
    case tertiary
    case neutral
}
 
struct ServiceCategory: Identifiable, Equatable,Hashable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let layout: ServiceCategoryLayout
    let accent: ServiceCategoryAccent
}
 
