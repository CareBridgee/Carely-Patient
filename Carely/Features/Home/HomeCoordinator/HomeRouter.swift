//
//  HomeRouter.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import SwiftUI
 
final class HomeRouter: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
 
    func push(to route: HomeRoute) {
        path.append(route)
    }
 
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
 
    func popToRoot() {
        path.removeLast(path.count)
    }
}
