//
//  SearchingOfferRepositoryProtocol.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation
protocol OfferSearchingRepositoryProtocol {
   
    func observeOffers() -> AsyncStream<BookingEvent>
    func connect()
    func disconnect()
}
