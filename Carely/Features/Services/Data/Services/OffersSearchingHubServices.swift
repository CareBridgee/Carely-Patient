//
//  OffersSearchingHubServices.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation

protocol OffersSearchingHubServicesProtocol {
    var onOfferReceived: ((NurseOffer) -> Void)? { get set }
    var onOfferCanceled: ((String) -> Void)? { get set }
    
    func connect()
    func disconnect()
}


final class OffersSearchingHubServices: OffersSearchingHubServicesProtocol {
    var onOfferReceived: ((NurseOffer) -> Void)?
    var onOfferCanceled: ((String) -> Void)?
    
    private var task: Task<Void, Never>?

    func connect() {
        task = Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            let offer1 = NurseOffer(id: "1", name: "Sarah Mitchell", title: "RN", price: 85.0, rating: 4.9, reviewsCount: 124, distance: 2.4, imageLink: "")
            await MainActor.run { onOfferReceived?(offer1) }

            try? await Task.sleep(nanoseconds: 3_000_000_000)
            let offer2 = NurseOffer(id: "2", name: "Elena Rodriguez", title: "RN", price: 78.0, rating: 5.0, reviewsCount: 45, distance: 5.1, imageLink: "")
            await MainActor.run { onOfferReceived?(offer2) }

            try? await Task.sleep(nanoseconds: 4_000_000_000)
            await MainActor.run { onOfferCanceled?("1") }
        }
    }

    func disconnect() {
        task?.cancel()
    }
}
