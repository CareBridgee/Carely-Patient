//
//  JSONDecoder+Default.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 24/07/2026.
//

import Foundation

extension JSONDecoder {
    static var standardDateDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoderInstance in
            let container = try decoderInstance.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = ISO8601DateFormatter.withFractionalSeconds.date(from: dateString) {
                return date
            }
            if let date = ISO8601DateFormatter.standard.date(from: dateString) {
                return date
            }
            for formatter in DateFormatter.fallbackFormatters {
                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
        }
        return decoder
    }
}

private extension ISO8601DateFormatter {
    static let standard = ISO8601DateFormatter()
    static let withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

private extension DateFormatter {
    static let fallbackFormatters: [DateFormatter] = {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]
        return formats.map { format in
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter
        }
    }()
}
