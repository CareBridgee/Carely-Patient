//
//  RefreshState.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Alamofire

actor RefreshState {

    private var isRefreshing = false
    private var pending: [(RetryResult) -> Void] = []

    func enqueue(_ completion: @escaping (RetryResult) -> Void) -> Bool {
        pending.append(completion)

        guard !isRefreshing else {
            return false
        }

        isRefreshing = true
        return true
    }

    func finish() -> [(RetryResult) -> Void] {
        isRefreshing = false

        let callbacks = pending
        pending.removeAll()

        return callbacks
    }
}
