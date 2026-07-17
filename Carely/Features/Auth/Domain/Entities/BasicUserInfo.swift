//
//  file.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
}

struct BasicUserInfo{
    let firstName: String
    let secondName: String
    let dateOfBirth: Date
    let Gender: Gender
}
