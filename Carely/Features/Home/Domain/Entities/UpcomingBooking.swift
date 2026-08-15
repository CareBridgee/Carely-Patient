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

    /// Maps the broader set of API statuses (used by History) down to the
    /// three visual states the Home preview card knows how to badge.
    init(visitStatus: VisitStatus) {
        switch visitStatus {
        case .pending:
            self = .pending
        case .confirmed, .accepted, .inProgress:
            self = .confirmed
        case .completed:
            self = .completed
        case .cancelled, .unknown:
            self = .pending
        }
    }
}
 
struct UpcomingBooking: Identifiable, Equatable {
    let id: String
    let providerName: String
    let providerImageName: String
    let providerImageUrl: String?
    let serviceName: String
    let status: BookingStatus
    let dateTimeText: String
}
