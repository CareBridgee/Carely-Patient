//
//  WelcomeViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
import UIKit
import GoogleSignIn

@MainActor
final class WelcomeViewModel: ObservableObject {
    private let router: AuthRouter
    private let repository: AuthRepositoryProtocol
    private let tokenStore: TokenStoring
    private let sessionManager: SessionManager
    private let onAuthFinished: () -> Void

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        router: AuthRouter,
        repository: AuthRepositoryProtocol,
        tokenStore: TokenStoring,
        sessionManager: SessionManager,
        onAuthFinished: @escaping () -> Void
    ) {
        self.router = router
        self.repository = repository
        self.tokenStore = tokenStore
        self.sessionManager = sessionManager
        self.onAuthFinished = onAuthFinished
    }

    func continueWithPhone() {
        router.push(to: .PhoneNumber(pendingToken: nil))
    }

    func continueWithGoogle(presentingWindow: UIViewController) {
        isLoading = true
        errorMessage = nil

        // Dynamically read IDs from Info.plist
        guard let iosClientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String,
              let webClientID = Bundle.main.object(forInfoDictionaryKey: "GIDServerClientID") as? String else {
            self.isLoading = false
            self.errorMessage = "Google Client IDs are missing in Info.plist"
            return
        }

        let config = GIDConfiguration(clientID: iosClientID, serverClientID: webClientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: presentingWindow) { [weak self] result, error in
            Task { @MainActor in
                guard let self = self else { return }

                if let error = error {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                    self.isLoading = false
                    self.errorMessage = "Failed to obtain ID token from Google."
                    return
                }

                await self.authenticateWithBackend(idToken: idToken)
            }
        }
    }

    private func authenticateWithBackend(idToken: String) async {
        do {
            let response = try await repository.googleLogin(idToken: idToken)
            isLoading = false

            if response.status == "AUTHENTICATED" {
                guard let access = response.accessToken,
                      let refresh = response.refreshToken,
                      let userDTO = response.user else { return }
                
                tokenStore.saveTokens(access: access, refresh: refresh)
                
                let user = User(
                    id: userDTO.id, phoneNumber: userDTO.phoneNumber, email: userDTO.email,
                    firstName: userDTO.firstName, lastName: userDTO.lastName, dateOfBirth: userDTO.dateOfBirth,
                    gender: userDTO.gender?.rawValue, profileImageUrl: userDTO.profileImageUrl,
                    isDeleted: userDTO.isDeleted, createdAt: userDTO.createdAt,
                    updatedAt: userDTO.updatedAt, lastLoginAt: userDTO.lastLoginAt, defaultProfileId: userDTO.defaultProfileId
                )
                
                sessionManager.setLoggedIn(user: user)
                
                let isNewUser = user.firstName == "User" || (user.lastName?.isEmpty ?? true)
                
                if isNewUser {
                    router.pushAsRoot(to: .PersonalInfo)
                } else {
                    onAuthFinished()
                }
                
            } else if response.status == "PHONE_REQUIRED" {
                router.push(to: .PhoneNumber(pendingToken: response.pendingToken))
            }
        } catch {
            isLoading = false
            self.errorMessage = error.carelyDescription
        }
    }
}
