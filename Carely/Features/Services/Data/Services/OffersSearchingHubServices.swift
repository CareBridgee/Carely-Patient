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

final class OffersSearchingSocketDataSource: OffersSearchingHubServicesProtocol {
    var onOfferReceived: ((NurseOffer) -> Void)?
    var onOfferCanceled: ((String) -> Void)?
    
    private let socketClient: SocketClientProtocol
    private let serviceRequestId: String
    private let decoder = JSONDecoder()
    
    init(socketClient: SocketClientProtocol, serviceRequestId: String) {
        self.socketClient = socketClient
        self.serviceRequestId = serviceRequestId
        self.setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        socketClient.onConnected = { [weak self] in
            guard let self = self else { return }
            self.socketClient.subscribe(to: "/topic/reservation/\(self.serviceRequestId)")
        }
        
        socketClient.onMessageReceived = { [weak self] destination, body in
            self?.handleMessage(body: body)
        }
        
        socketClient.onDisconnected = {
            // Optional: Handle disconnect (e.g. notify UI if needed)
        }
        
        socketClient.onError = { error in
            // Optional: Handle error
        }
    }
    
    func connect() {
        socketClient.connect()
    }
    
    func disconnect() {
        socketClient.unsubscribe(from: "/topic/reservation/\(serviceRequestId)")
        socketClient.disconnect()
    }
    
    private func handleMessage(body: String) {
        guard let data = body.data(using: .utf8) else { return }
        
        do {
            let event = try decoder.decode(ReservationEventDTO.self, from: data)
            
            switch event.type {
            case "OFFER_CREATED", "OFFER_UPDATED", "OFFER_COUNTERED", "OFFER_ACCEPTED":
                if let offerData = event.data {
                    let nurseOffer = NurseOffer(
                        id: offerData.id,
                        name: "Nurse \(String(offerData.nurseId.prefix(4)))", // Stub
                        title: "RN", // Stub
                        price: offerData.proposedPrice,
                        rating: 0.0, // Stub
                        reviewsCount: 0, // Stub
                        distance: 0.0, // Stub
                        imageLink: "" // Stub
                    )
                    DispatchQueue.main.async {
                        self.onOfferReceived?(nurseOffer)
                    }
                }
                
            case "OFFER_WITHDRAWN", "OFFER_REJECTED":
                let referenceEvent = try decoder.decode(OfferReferenceEventDTO.self, from: data)
                if let offerId = referenceEvent.data?.offerId {
                    DispatchQueue.main.async {
                        self.onOfferCanceled?(offerId)
                    }
                }
                
            default:
                break // Ignored event
            }
        } catch {
            print("[Socket Data Source] Error decoding message: \(error)")
        }
    }
}

private struct OfferReferenceEventDTO: Decodable {
    let data: OfferReferenceDTO?
}
