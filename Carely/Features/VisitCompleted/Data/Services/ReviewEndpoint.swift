//
//  ReviewEndpoint.swift
//  Carely
//
//  Created by Mona Zarea on 15/08/2026.
//

import Alamofire
import Foundation

enum ReviewEndpoint: Endpoint {
    case createReview(CreateReviewRequestDTO)

    var path: String {
        switch self {
        case .createReview:
            return "/api/v1/reviews"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        }
    }

    var parameters: Parameters? {
        switch self {
        case .createReview(let body):
            return body.asParameters()
        }
    }
}
