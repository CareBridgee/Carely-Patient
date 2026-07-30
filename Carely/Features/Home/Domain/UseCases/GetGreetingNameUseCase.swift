//
//  GetGreetingNameUseCase.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation

protocol GetGreetingNameUseCaseProtocol {
    func execute() async throws -> (name: String, imageUrl: String?)
}
 
final class GetGreetingNameUseCase: GetGreetingNameUseCaseProtocol {
    private let sessionManager: SessionManager
 
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
 
    func execute() async throws -> (name: String, imageUrl: String?) {
        let user = await sessionManager.currentUser
        
        let firstName = user?.firstName ?? "User"
        let imageUrl = user?.profileImageUrl
        
        return (name: firstName, imageUrl: imageUrl)
    }
}
