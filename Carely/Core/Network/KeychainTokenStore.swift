//
//  KeychainTokenStore.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation
import Security

protocol TokenStoring: Sendable {
    func saveTokens(access: String, refresh: String)
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens()
}

final class KeychainTokenStore: TokenStoring, @unchecked Sendable {

    // MARK: - Configuration
    
    private let isLoggingEnabled = false

    private let service = "com.carely.auth"
    private let accessKey = "accessToken"
    private let refreshKey = "refreshToken"
    private let accessibility = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    // MARK: - Public

    func saveTokens(access: String, refresh: String) {
        save(access, forKey: accessKey)
        save(refresh, forKey: refreshKey)
    }

    func getAccessToken() -> String? {
        read(accessKey)
    }

    func getRefreshToken() -> String? {
        read(refreshKey)
    }

    func clearTokens() {
        delete(accessKey)
        delete(refreshKey)
    }

    // MARK: - Keychain

    private func save(_ value: String, forKey key: String) {
        delete(key)

        var query = makeQuery(for: key)
        query[kSecValueData as String] = Data(value.utf8)
        query[kSecAttrAccessible as String] = accessibility

        let status = SecItemAdd(query as CFDictionary, nil)

        guard status == errSecSuccess else {
            log("Failed to save '\(key)'. OSStatus: \(status)")
            return
        }

        log("Saved '\(key)' successfully.")
    }

    private func read(_ key: String) -> String? {
        var query = makeQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?

        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard
            status == errSecSuccess,
            let data = result as? Data
        else {
            log("Failed to read '\(key)'. OSStatus: \(status)")
            return nil
        }

        log("Read '\(key)' successfully.")
        return String(data: data, encoding: .utf8)
    }

    private func delete(_ key: String) {
        let status = SecItemDelete(makeQuery(for: key) as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            log("Failed to delete '\(key)'. OSStatus: \(status)")
            return
        }

        log("Deleted '\(key)'.")
    }

    private func makeQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }

    // MARK: - Logging

    private func log(_ message: String) {
        guard isLoggingEnabled else { return }
        print("[KeychainTokenStore] \(message)")
    }
}
