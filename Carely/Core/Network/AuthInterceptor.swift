//
//  AuthInterceptor.swift
//  Carely
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {

    private let tokenStore: TokenStoring
    private let sessionMonitor: SessionMonitor
    private let unauthNetworkClient: NetworkClientProtocol
    private let refreshState = RefreshState()

    init(
        tokenStore: TokenStoring,
        sessionMonitor: SessionMonitor,
        unauthNetworkClient: NetworkClientProtocol
    ) {
        self.tokenStore = tokenStore
        self.sessionMonitor = sessionMonitor
        self.unauthNetworkClient = unauthNetworkClient
    }

    // MARK: - Adapt

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        if request.value(forHTTPHeaderField: AuthorizationType.headerKey) != nil {
            request.setValue(nil, forHTTPHeaderField: AuthorizationType.headerKey)
            completion(.success(request))
            return
        }

        if let token = tokenStore.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    // MARK: - Retry

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {

        guard request.response?.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }

        guard request.request?.value(forHTTPHeaderField: "Authorization") != nil else {
            completion(.doNotRetryWithError(error))
            return
        }

        Task {

            let shouldRefresh = await refreshState.enqueue(completion)

            guard shouldRefresh else {
                return
            }

            guard let refreshToken = tokenStore.getRefreshToken() else {
                let pending = await refreshState.finish()

                pending.forEach {
                    $0(.doNotRetryWithError(error))
                }

                sessionMonitor.sessionDidExpire()
                return
            }

            do {

                let response: AuthResponse = try await unauthNetworkClient.request(
                    AuthEndpoint.refresh(refreshToken: refreshToken)
                )

                tokenStore.saveTokens(
                    access: response.accessToken,
                    refresh: response.refreshToken
                )

                let pending = await refreshState.finish()

                pending.forEach {
                    $0(.retry)
                }

            } catch {

                tokenStore.clearTokens()

                let pending = await refreshState.finish()

                pending.forEach {
                    $0(.doNotRetryWithError(error))
                }

                sessionMonitor.sessionDidExpire()
            }
        }
    }
}

