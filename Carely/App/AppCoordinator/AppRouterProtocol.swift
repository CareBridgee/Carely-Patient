//
//  AppRouterProtocol.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import Foundation
import SwiftUI

@MainActor
protocol AppRouterProtocol: ObservableObject,  AnyObject{
    associatedtype Route: Hashable
    var path: NavigationPath { get set }
    var onBackClicked: (() -> Void)? { get set }
    
    func push(to route: Route)
    func pop()
    func popToRoot()
    
    func onBackTabbed()
}

extension AppRouterProtocol {
    func push(to route: Route) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot() {
        guard !path.isEmpty else { return }
        path.removeLast(path.count)
    }
    
    func onBackTabbed() {
        onBackClicked?()
        }
}
