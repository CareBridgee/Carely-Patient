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
}