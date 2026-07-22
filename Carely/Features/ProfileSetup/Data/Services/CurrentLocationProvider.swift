//
//  CurrentLocationProvider.swift
//  Carely
//
//  Created by Mohamed Ayman on 20/07/2026.
//

import CoreLocation

// MARK: - CurrentLocationProviderProtocol

protocol CurrentLocationProviderProtocol {
    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D?
    func requestCurrentCoordinate() async -> CLLocationCoordinate2D?
}

// MARK: - CurrentLocationProvider

final class CurrentLocationProvider: NSObject, CLLocationManagerDelegate, CurrentLocationProviderProtocol {

    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Never>?
    private var authorizationContinuation: CheckedContinuation<Bool, Never>?

    override init() {
        super.init()
        manager.delegate = self
    }

    func currentCoordinateIfAuthorized() async -> CLLocationCoordinate2D? {
        let status = manager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return nil
        }
        return await fetchCoordinate()
    }

    func requestCurrentCoordinate() async -> CLLocationCoordinate2D? {
        let status = manager.authorizationStatus

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            return await fetchCoordinate()
        case .notDetermined:
            let authorized = await requestAuthorization()
            guard authorized else { return nil }
            return await fetchCoordinate()
        default:
            return nil
        }
    }

    private func fetchCoordinate() async -> CLLocationCoordinate2D? {
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
        }
    }

    private func requestAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            self.authorizationContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationContinuation?.resume(returning: locations.first?.coordinate)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(returning: nil)
        locationContinuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        guard status != .notDetermined else { return }
        let authorized = status == .authorizedWhenInUse || status == .authorizedAlways
        authorizationContinuation?.resume(returning: authorized)
        authorizationContinuation = nil
    }
}
