//
//  UpcomingBooking.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
 

enum BookingStatus: String, Equatable {
    case confirmed = "Confirmed"
    case pending = "Pending"
    case completed = "Completed"
}
 
struct UpcomingBooking: Identifiable, Equatable {
    let id: String
    let providerName: String
    let providerImageName: String
    let serviceName: String
    let status: BookingStatus
    let dateTimeText: String
}
