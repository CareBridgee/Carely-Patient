//
//  ApiClient.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
import Alamofire

protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func requestWithoutResponse(_ endpoint: Endpoint) async throws
}

final class NetworkClient: NetworkClientProtocol {
    private let session: Session
    private let decoder: JSONDecoder
    var useLogs: Bool = true

    init(session: Session = .default, decoder: JSONDecoder = .standardDateDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        if useLogs { print("NetworkClient: requesting \(endpoint.method.rawValue) \(endpoint.url)") }
        let task = session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: buildHeaders(for: endpoint)
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)

        let response = await task.response
        
        switch response.result {
        case .success(let value):
            if useLogs { print("NetworkClient: request success for \(endpoint.url)") }
            return value
        case .failure(let error):
            if useLogs { print("NetworkClient: request failure for \(endpoint.url) with error: \(error)") }
            throw NetworkErrorMapper.map(error, data: response.data, decoder: decoder)
        }
    }

    func requestWithoutResponse(_ endpoint: Endpoint) async throws {
        if useLogs { print("NetworkClient: requesting (no response) \(endpoint.method.rawValue) \(endpoint.url)") }
        let task = session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: buildHeaders(for: endpoint)
        )
        .validate()
        .serializingData(emptyResponseCodes: [200, 201, 204, 205])

        let response = await task.response
        
        if let error = response.error {
            if useLogs { print("NetworkClient: request failure for \(endpoint.url) with error: \(error)") }
            throw NetworkErrorMapper.map(error, data: response.data, decoder: decoder)
        } else {
            if useLogs { print("NetworkClient: request success for \(endpoint.url)") }
        }
    }

    private func buildHeaders(for endpoint: Endpoint) -> HTTPHeaders {
        var headers = endpoint.headers ?? HTTPHeaders()
        if endpoint.authorizationType == .none {
            headers.add(name: AuthorizationType.headerKey, value: "true")
        }
        return headers
    }
}
// MARK: 
/*
 This is how you will wire up the generic NetworkClient in your DI Container
 or App level once the Auth module is built.

 class AppDIContainer {
     
     // 1. Create the Auth-specific interceptor (lives in Auth feature)
     let tokenStore = KeychainTokenStore()
     let authInterceptor = AuthInterceptor(tokenStore: tokenStore)
     
     // 2. Wrap it in an Alamofire Session
     let authenticatedSession = Session(interceptor: authInterceptor)
     
     // 3. Inject it into your generic NetworkClient
     let networkClient: NetworkClientProtocol = NetworkClient(session: authenticatedSession)
     
     // 4. Inject the client into your Repositories!
     let patientRepository = PatientRepositoryImpl(networkClient: networkClient)
     let nurseRepository = NurseRepositoryImpl(networkClient: networkClient)
 }
 */
