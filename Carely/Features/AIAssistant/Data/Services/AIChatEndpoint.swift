//
//  AIChatEndpoint.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Alamofire
import Foundation

enum AIChatEndpoint: Endpoint {
    case sendMessage(message: String)

    var path: String {
        switch self {
        case .sendMessage:
            return "/api/v1/chat"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendMessage:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .sendMessage(let message):
            return ["message": message]
        }
    }

    var authorizationType: AuthorizationType {
        .bearer
    }
}
