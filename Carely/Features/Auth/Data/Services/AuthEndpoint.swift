//
//  AuthEndpoint.swift
//  Carely
//

import Alamofire
import Foundation
enum AuthEndpoint: Endpoint {
    case login(phoneNumber: String)
    case requestOTPDev(phoneNumber: String)
    case verifyOTP(phoneNumber: String, otp: String, pendingToken: String?)
        case googleLogin(idToken: String)
    case profile(phoneNumber: String)
    case refresh(refreshToken: String)
    case logout(refreshToken: String)
    case getDefaultProfile
    case updateProfile(id: String, request: PersonalInfoRequestDTO)
    case updateUser(request: UserUpdateRequestDTO)
    case getUser
    case uploadFile

    var path: String {
        switch self {
        case .login: return "/api/v1/auth/login"
        case .requestOTPDev: return "/api/v1/auth/dev/request-otp"
        case .verifyOTP: return "/api/v1/auth/verify-otp"
        case .googleLogin: return "/api/v1/auth/google"
        case .profile: return "/api/v1/auth/profile"
        case .refresh: return "/api/v1/auth/refresh"
        case .logout: return "/api/v1/auth/logout"
        case .getDefaultProfile: return "/api/v1/profiles/default"
        case .updateProfile(let id, _): return "/api/v1/profiles/\(id)"
        case .updateUser, .getUser: return "/api/v1/users/me"
        case .uploadFile: return "/api/v1/upload"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile, .getDefaultProfile, .getUser:    
            return .get
        case .updateProfile, .updateUser:
            return .put
        default:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .login(let p): return ["phoneNumber": p]
        case .requestOTPDev(let p): return ["phoneNumber": p]
        case .verifyOTP(let p, let otp, let pendingToken):
                    var params: [String: Any] = ["phoneNumber": p, "otp": otp]
                    if let pendingToken = pendingToken { params["pendingToken"] = pendingToken }
                    return params
                case .googleLogin(let idToken):
                    return ["idToken": idToken]
        case .profile(let p): return ["phoneNumber": p]
        case .refresh(let r): return ["refreshToken": r]
        case .logout(let r): return ["refreshToken": r]
        case .getDefaultProfile, .uploadFile, .getUser: return nil
        case .updateProfile(_, let request): return request.asParameters()
        case .updateUser(let request): return request.asParameters()
        }
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .login, .requestOTPDev, .verifyOTP, .refresh: return .none
        default: return .bearer
        }
    }
}
