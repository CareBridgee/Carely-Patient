//
//  VisitRating.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
struct VisitRating: Equatable {
    let visitId: String
    let stars: Int
    let reviewText: String
    let isAnonymous: Bool

    init(visitId: String, stars: Int, reviewText: String = "", isAnonymous: Bool = false) {
        self.visitId = visitId
        self.stars = stars
        self.reviewText = reviewText
        self.isAnonymous = isAnonymous
    }
}
