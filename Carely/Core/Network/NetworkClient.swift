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
    func upload<T: Decodable>(_ endpoint: Endpoint, data: Data, fileName: String, mimeType: String, fieldName: String) async throws -> T
    /// Sends a multipart/form-data request (text fields + an optional file part) without decoding a response body.
    /// Needed for endpoints (like PUT /users/me) whose Swagger contract is `multipart/form-data` — sending those
    /// as JSON causes the server to receive no fields at all since it never parses the body.
    func requestMultipartWithoutResponse(
        _ endpoint: Endpoint,
        textParameters: [String: String],
        fileData: Data?,
        fileFieldName: String,
        fileName: String,
        mimeType: String
    ) async throws
    /// Same as `requestMultipartWithoutResponse` but decodes a response body. Needed for multipart
    /// endpoints like POST /profiles that return the created/updated resource.
    func requestMultipart<T: Decodable>(
        _ endpoint: Endpoint,
        textParameters: [String: String],
        fileData: Data?,
        fileFieldName: String,
        fileName: String,
        mimeType: String
    ) async throws -> T
}

extension NetworkClientProtocol {
    func requestMultipartWithoutResponse(
        _ endpoint: Endpoint,
        textParameters: [String: String]
    ) async throws {
        try await requestMultipartWithoutResponse(
            endpoint,
            textParameters: textParameters,
            fileData: nil,
            fileFieldName: "",
            fileName: "",
            mimeType: ""
        )
    }

    func requestMultipart<T: Decodable>(
        _ endpoint: Endpoint,
        textParameters: [String: String]
    ) async throws -> T {
        try await requestMultipart(
            endpoint,
            textParameters: textParameters,
            fileData: nil,
            fileFieldName: "",
            fileName: "",
            mimeType: ""
        )
    }
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
            if useLogs {
                print("NetworkClient: request failure for \(endpoint.url) with error: \(error)")
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("NetworkClient: SERVER ERROR PAYLOAD (\(endpoint.url)): \(str)")
                }
            }
            throw NetworkErrorMapper.map(error, data: response.data, response: response.response, decoder: decoder)
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
            if useLogs {
                print("NetworkClient: request failure for \(endpoint.url) with error: \(error)")
                if let data = response.data, let str = String(data: data, encoding: .utf8) {
                    print("NetworkClient: SERVER ERROR PAYLOAD (\(endpoint.url)): \(str)")
                }
            }
            throw NetworkErrorMapper.map(error, data: response.data, response: response.response, decoder: decoder)
        } else {
            if useLogs { print("NetworkClient: request success for \(endpoint.url)") }
        }
    }
    func upload<T: Decodable>(
           _ endpoint: Endpoint,
           data: Data,
           fileName: String,
           mimeType: String,
           fieldName: String
       ) async throws -> T {
           if useLogs { print("NetworkClient: uploading \(fileName) to \(endpoint.url)") }

           let task = session.upload(
               multipartFormData: { form in
                   form.append(data, withName: fieldName, fileName: fileName, mimeType: mimeType)
               },
               to: endpoint.url,
               headers: buildHeaders(for: endpoint)
           )
           .validate()
           .serializingDecodable(T.self, decoder: decoder)

           let response = await task.response
           switch response.result {
           case .success(let value):
               if useLogs { print("NetworkClient: upload success for \(endpoint.url)") }
               return value
            case .failure(let error):
                if useLogs {
                    print("NetworkClient: upload failure for \(endpoint.url) with error: \(error)")
                    if let data = response.data, let str = String(data: data, encoding: .utf8) {
                        print("NetworkClient: SERVER ERROR PAYLOAD (\(endpoint.url)): \(str)")
                    }
                }
                throw NetworkErrorMapper.map(error, data: response.data, response: response.response, decoder: decoder)
           }
       }
    func requestMultipartWithoutResponse(
        _ endpoint: Endpoint,
        textParameters: [String: String],
        fileData: Data?,
        fileFieldName: String,
        fileName: String,
        mimeType: String
    ) async throws {
        if useLogs { print("NetworkClient: multipart requesting (no response) \(endpoint.method.rawValue) \(endpoint.url)") }

        let task = buildMultipartUploadRequest(
            endpoint, textParameters: textParameters,
            fileData: fileData, fileFieldName: fileFieldName, fileName: fileName, mimeType: mimeType
        )
        .validate()
        .serializingData(emptyResponseCodes: [200, 201, 204, 205])

        let response = await task.response

        if let error = response.error {
            if useLogs { print("NetworkClient: multipart request failure for \(endpoint.url) with error: \(error)") }
            throw NetworkErrorMapper.map(error, data: response.data, response: response.response,decoder: decoder)
        } else {
            if useLogs { print("NetworkClient: multipart request success for \(endpoint.url)") }
        }
    }

    func requestMultipart<T: Decodable>(
        _ endpoint: Endpoint,
        textParameters: [String: String],
        fileData: Data?,
        fileFieldName: String,
        fileName: String,
        mimeType: String
    ) async throws -> T {
        if useLogs { print("NetworkClient: multipart requesting \(endpoint.method.rawValue) \(endpoint.url)") }

        let task = buildMultipartUploadRequest(
            endpoint, textParameters: textParameters,
            fileData: fileData, fileFieldName: fileFieldName, fileName: fileName, mimeType: mimeType
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)

        let response = await task.response
        switch response.result {
        case .success(let value):
            if useLogs { print("NetworkClient: multipart request success for \(endpoint.url)") }
            return value
        case .failure(let error):
            if useLogs { print("NetworkClient: multipart request failure for \(endpoint.url) with error: \(error)") }
            throw NetworkErrorMapper.map(error, data: response.data,response: response.response, decoder: decoder)
        }
    }

    private func buildMultipartUploadRequest(
        _ endpoint: Endpoint,
        textParameters: [String: String],
        fileData: Data?,
        fileFieldName: String,
        fileName: String,
        mimeType: String
    ) -> UploadRequest {
        session.upload(
            multipartFormData: { form in
                for (key, value) in textParameters {
                    if let data = value.data(using: .utf8) {
                        form.append(data, withName: key)
                    }
                }
                if let fileData, !fileFieldName.isEmpty {
                    form.append(fileData, withName: fileFieldName, fileName: fileName, mimeType: mimeType)
                }
            },
            to: endpoint.url,
            method: endpoint.method,
            headers: buildHeaders(for: endpoint)
        )
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
