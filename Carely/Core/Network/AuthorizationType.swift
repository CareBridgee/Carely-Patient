//
//  AuthorizationType.swift
//  Carely
//
//  Created by Mohamed Ayman on 25/07/2026.
//

import Foundation

enum AuthorizationType {
    case none
    case bearer
}

extension AuthorizationType {
    static let headerKey = "X-Requires-Auth"
}
