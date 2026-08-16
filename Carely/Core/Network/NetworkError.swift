//
//  NetworkError.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 24/07/2026.
//


import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case unauthorized
    case sessionExpired
    case decodingFailed(underlying: Error)
    case server(statusCode: Int, message: String?)
    case cancelled
    case unknown(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The request URL was invalid."
        case .noInternetConnection: return "No internet connection. Check your network and try again."
        case .timeout: return "The request timed out. Please try again."
        case .unauthorized: return "Your session has expired. Please sign in again."
        case .sessionExpired: return "Your session has expired. Please sign in again."
        case .decodingFailed: return "We couldn't process the server's response."
        case .server(_, let message): return message ?? "Something went wrong. Please try again."
        case .cancelled: return "The request was cancelled."
        case .unknown: return "An unexpected error occurred."
        }
    }

    /// Whether a "Retry" action makes sense for this error. Session/auth
    /// failures should route the user to sign in again instead of retrying.
    var isRetryable: Bool {
        switch self {
        case .unauthorized, .sessionExpired, .cancelled:
            return false
        default:
            return true
        }
    }
}

extension Error {
    /// The exact message the server sent, if this error originated from a
    /// server response. Falls back to `nil` (never a hardcoded string) so
    /// callers can decide their own fallback at the UI layer.
    var serverMessage: String? {
        guard case .server(_, let message) = self as? NetworkError else { return nil }
        return message
    }

    /// The best user-facing description for any error: the network layer's
    /// friendly copy when available, otherwise the system description.
    var carelyDescription: String {
        (self as? LocalizedError)?.errorDescription ?? localizedDescription
    }
}
