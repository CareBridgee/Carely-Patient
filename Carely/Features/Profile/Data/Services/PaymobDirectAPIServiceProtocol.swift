//
//  PaymobDirectAPIServiceProtocol.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation

protocol PaymobDirectAPIServiceProtocol {
    /// Runs auth -> order -> payment_key and returns the ready-to-load iframe URL.
    func createCheckoutURL(amount: Double, billing: PaymobBillingData, merchantOrderId: Int) async throws -> URL
}

enum PaymobDirectError: Error {
    case invalidResponse
    case http(Int)
}

final class PaymobDirectAPIService: PaymobDirectAPIServiceProtocol {
    private let baseURL = URL(string: "https://accept.paymob.com/api")!
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func createCheckoutURL(amount: Double, billing: PaymobBillingData, merchantOrderId: Int) async throws -> URL {
        let amountCents = Int(amount * 100)

        let authToken = try await authenticate()
        let orderId = try await registerOrder(authToken: authToken, amountCents: amountCents, merchantOrderId: merchantOrderId)
        let paymentToken = try await requestPaymentKey(authToken: authToken, orderId: orderId, amountCents: amountCents, billing: billing)

        var components = URLComponents(url: baseURL.appendingPathComponent("acceptance/iframes/\(PaymobConfig.iframeId)"), resolvingAgainstBaseURL: false)!
        components.queryItems = [URLQueryItem(name: "payment_token", value: paymentToken)]
        guard let url = components.url else { throw PaymobDirectError.invalidResponse }
        return url
    }

    private func authenticate() async throws -> String {
        let body = ["api_key": PaymobConfig.publicKey]
        let dto: PaymobAuthResponseDTO = try await post("auth/tokens", body: body)
        return dto.token
    }

    private func registerOrder(authToken: String, amountCents: Int, merchantOrderId: Int) async throws -> Int {
        let body: [String: Any] = [
            "auth_token": authToken,
            "delivery_needed": false,
            "amount_cents": amountCents,
            "currency": PaymobConfig.currency,
            "merchant_order_id": merchantOrderId,
            "items": []
        ]
        let dto: PaymobOrderResponseDTO = try await post("ecommerce/orders", body: body)
        return dto.id
    }

    private func requestPaymentKey(authToken: String, orderId: Int, amountCents: Int, billing: PaymobBillingData) async throws -> String {
        let billingDict = try JSONSerialization.jsonObject(with: JSONEncoder().encode(billing)) as? [String: Any] ?? [:]
        let body: [String: Any] = [
            "auth_token": authToken,
            "amount_cents": amountCents,
            "expiration": 3600,
            "order_id": orderId,
            "billing_data": billingDict,
            "currency": PaymobConfig.currency,
            "integration_id": PaymobConfig.integrationId
        ]
        let dto: PaymobPaymentKeyResponseDTO = try await post("acceptance/payment_keys", body: body)
        return dto.token
    }

    private func post<T: Decodable>(_ path: String, body: [String: Any]) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw PaymobDirectError.invalidResponse }
        guard (200..<300).contains(http.statusCode) else { throw PaymobDirectError.http(http.statusCode) }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
