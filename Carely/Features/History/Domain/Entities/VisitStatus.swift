//
//  VisitStatus.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
/// Mirrors the backend's `serviceRequest.status` enum (PENDING, ACCEPTED,
/// IN_PROGRESS, COMPLETED, CANCELLED — per API context doc). Decoding is
/// case-insensitive and unknown values fall back to `.unknown` instead of
/// throwing, so a status the client doesn't recognize yet won't crash the list.
enum VisitStatus: String, Equatable {
    case pending = "PENDING"
    case confirmed = "CONFIRMED"
    case accepted = "ACCEPTED"
    case inProgress = "IN_PROGRESS"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    case unknown = "UNKNOWN"
 
    init(rawStatus: String?) {
        guard let rawStatus, let match = VisitStatus(rawValue: rawStatus.uppercased()) else {
            self = .unknown
            return
        }
        self = match
    }
 
    var displayText: String {
        switch self {
        case .pending: return "Pending"
        case .confirmed, .accepted: return "Confirmed"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .unknown: return "Unknown"
        }
    }
}
 
