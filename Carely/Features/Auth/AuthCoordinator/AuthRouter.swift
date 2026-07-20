//
//  AuthRouter.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import Foundation
import SwiftUI

final class AuthRouter: ObservableObject {
    @Published var path : NavigationPath = NavigationPath()
    
    func push(to route:AuthRoute){
        path.append(route)
    }
    
    func pop(){
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func popToRoot(){
        path.removeLast(path.count)
    }
    
}
