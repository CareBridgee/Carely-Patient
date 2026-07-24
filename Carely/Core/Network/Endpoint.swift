//
//  Endpoint.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 24/07/2026.
//


import Alamofire
import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Endpoint {
    var baseURL: String { NetworkConfiguration.baseURL }
    var url: String { baseURL + path }
    
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
    var encoding: ParameterEncoding { 
        method == .get ? URLEncoding.default : JSONEncoding.default 
    }
}
// MARK: - 💡 HOW TO USE IN A FEATURE
/*

 
 enum PatientEndpoint: Endpoint {
     case getPatientProfile(id: Int)
     case updatePatientInfo(id: Int, name: String)
     
     var path: String {
         switch self {
         case .getPatientProfile(let id):
             return "/api/v1/patients/\(id)"
         case .updatePatientInfo(let id, _):
             return "/api/v1/patients/\(id)"
         }
     }
     
     var method: HTTPMethod {
         switch self {
         case .getPatientProfile:
             return .get
         case .updatePatientInfo:
             return .put
         }
     }
     
     var parameters: Parameters? {
         switch self {
         case .getPatientProfile:
             return nil // GET requests usually don't have body parameters
         case .updatePatientInfo(_, let name):
             return ["name": name]
         }
     }
 }
*/
