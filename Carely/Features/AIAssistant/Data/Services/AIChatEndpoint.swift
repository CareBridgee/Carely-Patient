//
//  AIChatEndpoint.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Alamofire
import Foundation

enum AIChatEndpoint: Endpoint {
    case sendMessage(profileId: String, message: String)
    case resetChat(profileId: String)

    var path: String {
        switch self {
        case .sendMessage:
            return "/api/v1/chat"
        case .resetChat:
            return "/api/v1/chat/reset"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendMessage, .resetChat:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .sendMessage(let profileId, let message):
            return [
                "profileId": profileId,
                "message": message
            ]
        case .resetChat(let profileId):
            return [
                "profileId": profileId
            ]
        }
    }

    var authorizationType: AuthorizationType {
        .bearer
    }
}

