//
//  HomeRoute.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 
enum HomeRoute: Hashable {
    case serviceCategories
    case serviceDetails(serviceId: String)
}
