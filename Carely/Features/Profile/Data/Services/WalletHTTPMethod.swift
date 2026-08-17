//
//  WalletHTTPMethod.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//

import Alamofire


//
//  WalletEndpoint.swift
//  Carely
//

enum WalletEndpoint: Endpoint {
    case currentUser
    case getCredit(userId: String)
    case updateCredit(userId: String, amount: Double, operation: String)

    var path: String {
        switch self {
        case .currentUser:
            return "/api/v1/users/me"
        case .getCredit(let userId):
            return "/api/v1/users/\(userId)/credit"
        case .updateCredit(let userId, _, _):
            return "/api/v1/users/\(userId)/credit"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .currentUser, .getCredit:
            return .get
        case .updateCredit:
            return .patch
        }
    }

    var parameters: Parameters? {
        switch self {
        case .currentUser, .getCredit:
            return nil
        case .updateCredit(_, let amount, let operation):
            return ["amount": amount, "operation": operation]
        }
    }
}
