//
//  ProfileCoordinator.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import Foundation
import SwiftUI

@MainActor
final class ProfileCoordinator: ObservableObject {

    @Published var path = NavigationPath()

    var onLoggedOut: (() -> Void)?
    var onAddFamilyMember: (() -> Void)?
    var onFamilyMembersViewModelCreated: ((FamilyMembersViewModel) -> Void)?

    func push(_ route: ProfileRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func logoutTapped() {
        onLoggedOut?()
    }

    func addFamilyMemberTapped() {
        onAddFamilyMember?()
    }
}
