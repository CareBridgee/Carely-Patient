//
//  OffersEvent.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
// Domain Layer
enum BookingEvent {
    case offerReceived(NurseOffer)
    case offerCanceled(String)
    case searchCompleted
}
