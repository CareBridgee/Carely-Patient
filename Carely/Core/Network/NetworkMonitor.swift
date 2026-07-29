//
//  NetworkMonitor.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//


import Foundation
import Network

public final class NetworkMonitor: ObservableObject {
    public static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    @Published public private(set) var isConnected: Bool = true

    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
