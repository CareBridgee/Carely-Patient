//
//  BasicHealthInfo.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

struct BasicHealthInfo {
    var height: Double?
    var weight: Double?
    var bloodType : String
}
extension BasicHealthInfo: Equatable {
    static func == (lhs: BasicHealthInfo, rhs: BasicHealthInfo) -> Bool {
        return lhs.height == rhs.height &&
               lhs.weight == rhs.weight &&
               lhs.bloodType == rhs.bloodType
    }
}
