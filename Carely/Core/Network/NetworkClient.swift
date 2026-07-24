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
    // MARK: for (AUTH FEATURE INJECTION)
        //
        // Do NOT modify this class to add tokens, headers, or 401 retry logic.
        // This network layer is strictly generic infrastructure.
        //
        // To add Authentication logic (like an AuthInterceptor for token refresh):
        // 1. Create your `AuthInterceptor` in the Auth Module.
        // 2. Create a custom Alamofire `Session`: `let session = Session(interceptor: authInterceptor)`
        // 3. Inject that session here when resolving your dependencies.
        //
        // See the DIContainer example at the bottom of this file.
    init(session: Session = .default, decoder: JSONDecoder = .standardDateDecoder) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let task = session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)

        let response = await task.response
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw NetworkErrorMapper.map(error, data: response.data, decoder: decoder)
        }
    }

    func requestWithoutResponse(_ endpoint: Endpoint) async throws {
        let task = session.request(
            endpoint.url,
            method: endpoint.method,
            parameters: endpoint.parameters,
            encoding: endpoint.encoding,
            headers: endpoint.headers
        )
        .validate()
        .serializingData()

        let response = await task.response
        
        if let error = response.error {
            throw NetworkErrorMapper.map(error, data: response.data, decoder: decoder)
        }
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
