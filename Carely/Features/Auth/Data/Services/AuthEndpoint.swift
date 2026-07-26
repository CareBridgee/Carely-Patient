//
//  AuthEndpoint.swift
//  Carely
//

import Alamofire
import Foundation

enum AuthEndpoint: Endpoint {
    case login(phoneNumber: String)
    case requestOTPDev(phoneNumber: String) // for developer not release
    case verifyOTP(phoneNumber: String, otp: String)
    case profile(phoneNumber: String)
    case refresh(refreshToken: String)
    case logout(refreshToken: String)

    var path: String {
        switch self {
        case .login:
            return "/api/v1/auth/login"
        case .requestOTPDev:
            return "/api/v1/auth/dev/request-otp"
        case .verifyOTP:
            return "/api/v1/auth/verify-otp"
        case .profile:
            return "/api/v1/auth/profile"
        case .refresh:
            return "/api/v1/auth/refresh"
        case .logout:
            return "/api/v1/auth/logout"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile:
            return .get
        default:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .requestOTPDev(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .verifyOTP(let phoneNumber, let otp):
            return ["phoneNumber": phoneNumber, "otp": otp]
        case .profile(let phoneNumber):
            return ["phoneNumber": phoneNumber]
        case .refresh(let refreshToken):
            return ["refreshToken": refreshToken]
        case .logout(let refreshToken):
            return ["refreshToken": refreshToken]
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .login, .requestOTPDev, .verifyOTP, .refresh:
            return .none
        case .profile, .logout:
            return .bearer
        }
    }
}
