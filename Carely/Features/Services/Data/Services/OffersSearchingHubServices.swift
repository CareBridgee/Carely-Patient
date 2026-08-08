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
            let key = "Offers_\(serviceRequestId)"
            
            socketClient.onConnectedListeners[key] = { [weak self] in
                guard let self = self else { return }
                self.socketClient.subscribe(to: "/topic/reservation/\(self.serviceRequestId)")
            }

            socketClient.onMessageReceivedListeners[key] = { [weak self] destination, body in
                guard let self = self else { return }
                if destination.contains("/topic/reservation/\(self.serviceRequestId)") {
                    self.handleMessage(body: body)
                }
            }
        }

        func disconnect() {
            let key = "Offers_\(serviceRequestId)"
                    
                    socketClient.unsubscribe(from: "/topic/reservation/\(serviceRequestId)")
                    
                    socketClient.onConnectedListeners.removeValue(forKey: key)
                    socketClient.onMessageReceivedListeners.removeValue(forKey: key)
                    }
    
    func connect() {
        socketClient.connect()
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
