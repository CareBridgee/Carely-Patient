//
//  FlexibleTimeDTO.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
/// The API context doc describes `preferredTime` on the request body as an
/// object `{hour, minute, second, nano}` (a serialized `java.time.LocalTime`).
/// It isn't confirmed whether GET responses echo the same shape or serialize
/// it as a plain "HH:mm:ss" string instead, so this decodes either without
/// throwing — if you find the live response uses something else entirely,
/// this is the only place that needs updating.
struct FlexibleTimeDTO: Decodable, Equatable {
    let hour: Int
    let minute: Int
 
    private enum CodingKeys: String, CodingKey {
        case hour, minute
    }
 
    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self),
           let hour = try? container.decode(Int.self, forKey: .hour),
           let minute = try? container.decode(Int.self, forKey: .minute) {
            self.hour = hour
            self.minute = minute
            return
        }
 
        let single = try decoder.singleValueContainer()
        if let text = try? single.decode(String.self) {
            let parts = text.split(separator: ":")
            self.hour = parts.count > 0 ? Int(parts[0]) ?? 0 : 0
            self.minute = parts.count > 1 ? Int(parts[1]) ?? 0 : 0
            return
        }
 
        self.hour = 0
        self.minute = 0
    }
 
    var displayText: String {
        String(format: "%02d:%02d", hour, minute)
    }
}
 
