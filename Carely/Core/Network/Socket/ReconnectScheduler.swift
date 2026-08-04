//
//  ReconnectScheduler.swift
//  Carely
//
//  Created by Mohamed Ayman on 03/08/2026.
//

import Foundation

final class ReconnectScheduler {

    private let maxRetries: Int
    private let baseDelayMs: Double

    private var attempt = 0
    private var task: Task<Void, Never>?

    init(maxRetries: Int = 10, baseDelayMs: Double = 2000) {
        self.maxRetries = maxRetries
        self.baseDelayMs = baseDelayMs
    }


    func scheduleNext(_ onReconnect: @escaping (_ attempt: Int) -> Void) {
        guard attempt < maxRetries else { return }

        task?.cancel()
        let currentAttempt = attempt
        attempt += 1

        let delayMs = baseDelayMs * pow(2.0, Double(currentAttempt))
        task = Task {
            try? await Task.sleep(nanoseconds: UInt64(delayMs * 1_000_000))
            guard !Task.isCancelled else { return }
            onReconnect(currentAttempt + 1)
        }
    }

    func reset() {
        attempt = 0
        task?.cancel()
        task = nil
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
