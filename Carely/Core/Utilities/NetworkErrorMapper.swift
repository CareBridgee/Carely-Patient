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
            if code == 401 { return .unauthorized }
            let serverMessage = data.flatMap { try? decoder.decode(ServerErrorBody.self, from: $0) }?.message
            return .server(statusCode: code, message: serverMessage)
        }

        if case .responseSerializationFailed(let reason) = afError,
           case .decodingFailed(let decodingError) = reason {
            return .decodingFailed(underlying: decodingError)
        }

        return .unknown(underlying: afError)
    }
}

private struct ServerErrorBody: Decodable {
    let message: String?
    let error: String?
}
