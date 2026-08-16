//
//  NetworkErrorMapper.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 24/07/2026.
//


import Foundation
import Alamofire

enum NetworkErrorMapper {
    static func map(_ error: Error, data: Data?, response: HTTPURLResponse?, decoder: JSONDecoder) -> NetworkError {
        guard let afError = error as? AFError else {
            return .unknown(underlying: error)
        }

        if let urlError = afError.underlyingError as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost: return .noInternetConnection
            case .timedOut: return .timeout
            case .cancelled: return .cancelled
            default: break
            }
        }

        if let code = response?.statusCode, code >= 400 {
            let serverMessage = data.flatMap { ServerErrorBody(data: $0, decoder: decoder) }?.resolvedMessage
            if code == 401 { return .unauthorized }
            return .server(statusCode: code, message: serverMessage)
        }

        if case .responseSerializationFailed(let reason) = afError,
           case .decodingFailed(let decodingError) = reason {
            return .decodingFailed(underlying: decodingError)
        }

        return .unknown(underlying: afError)
    }
}

/// Decodes the assortment of error shapes our backends return so the caller
/// always gets the exact string the server sent, never a hardcoded fallback.
///
/// Supported shapes:
/// - `{ "message": "..." }`
/// - `{ "error": "..." }`
/// - `{ "errors": ["...", "..."] }`
/// - `{ "errors": [{ "message": "..." }, ...] }`
/// - `{ "errors": { "field": ["...", "..."] } }` (ASP.NET-style ModelState)
private struct ServerErrorBody: Decodable {
    let message: String?
    let error: String?
    let errors: ErrorsField?

    enum CodingKeys: String, CodingKey {
        case message, error, errors, title, detail
    }

    private let title: String?
    private let detail: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        errors = try container.decodeIfPresent(ErrorsField.self, forKey: .errors)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
    }

    /// Convenience initializer that returns nil instead of throwing so callers
    /// can `flatMap` straight from raw response `Data`.
    init?(data: Data, decoder: JSONDecoder) {
        guard let decoded = try? decoder.decode(ServerErrorBody.self, from: data) else { return nil }
        self = decoded
    }

    /// The best single human-readable string this payload can offer, preferring
    /// the server's exact wording over anything synthesized locally.
    var resolvedMessage: String? {
        if let message, !message.isEmpty { return message }
        if let error, !error.isEmpty { return error }
        if let detail, !detail.isEmpty { return detail }
        if let fromErrors = errors?.resolvedMessage { return fromErrors }
        if let title, !title.isEmpty { return title }
        return nil
    }
}

/// The `errors` field varies by backend: a flat array of strings, an array of
/// objects each with a `message`, or a dictionary of field -> [messages].
private enum ErrorsField: Decodable {
    case stringList([String])
    case objectList([[String: String]])
    case fieldMap([String: [String]])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let strings = try? container.decode([String].self) {
            self = .stringList(strings)
            return
        }
        if let objects = try? container.decode([[String: String]].self) {
            self = .objectList(objects)
            return
        }
        if let map = try? container.decode([String: [String]].self) {
            self = .fieldMap(map)
            return
        }
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Unsupported `errors` payload shape"
        )
    }

    /// Joins every message found into a single, comma-separated sentence so
    /// nothing the server reported gets silently dropped.
    var resolvedMessage: String? {
        switch self {
        case .stringList(let strings):
            let cleaned = strings.filter { !$0.isEmpty }
            return cleaned.isEmpty ? nil : cleaned.joined(separator: ", ")
        case .objectList(let objects):
            let cleaned = objects.compactMap { $0["message"] ?? $0.values.first }
            return cleaned.isEmpty ? nil : cleaned.joined(separator: ", ")
        case .fieldMap(let map):
            let cleaned = map.values.flatMap { $0 }.filter { !$0.isEmpty }
            return cleaned.isEmpty ? nil : cleaned.joined(separator: ", ")
        }
    }
}
