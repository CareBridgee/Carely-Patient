//
//  Encodable+Parameters.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 28/07/2026.
//

import Foundation
import Alamofire

public extension Encodable {
    func asParameters() -> Parameters? {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            return nil
        }
        return dictionary
    }
}
