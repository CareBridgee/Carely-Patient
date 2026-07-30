//
//  CloudinaryConfiguration.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 29/07/2026.
//


import Foundation
import UIKit


struct CloudinaryConfiguration {
    let cloudName: String
    let uploadPreset: String

    static let carely = CloudinaryConfiguration(
        cloudName: "uy4vxp6c",
        uploadPreset: "ios_unsigned_preset"
    )
}

// MARK: - Response

struct CloudinaryUploadResponse: Decodable {
    let secureUrl: String
    let publicId: String
    let format: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case secureUrl = "secure_url"
        case publicId = "public_id"
        case format, width, height
    }
}

// MARK: - Errors

enum CloudinaryUploadError: LocalizedError {
    case invalidImageData
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, message: String?)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidImageData: return "Couldn't convert the image to JPEG data."
        case .invalidURL: return "Invalid Cloudinary upload URL."
        case .invalidResponse: return "Received an unexpected response from Cloudinary."
        case .serverError(let code, let message): return message ?? "Upload failed (status \(code))."
        case .decodingFailed: return "Couldn't parse Cloudinary's response."
        }
    }
}

// MARK: - Service

protocol CloudinaryUploadServiceProtocol {
    func uploadImage(_ image: UIImage, compressionQuality: CGFloat) async throws -> CloudinaryUploadResponse
}

final class CloudinaryUploadService: CloudinaryUploadServiceProtocol {

    private let configuration: CloudinaryConfiguration
    private let session: URLSession

    init(configuration: CloudinaryConfiguration = .carely, session: URLSession = .shared) {
        self.configuration = configuration
        self.session = session
    }

    func uploadImage(_ image: UIImage, compressionQuality: CGFloat = 0.8) async throws -> CloudinaryUploadResponse {
            guard let imageData = image.jpegData(compressionQuality: compressionQuality) else {
                throw CloudinaryUploadError.invalidImageData
            }
            print("☁️ Cloudinary upload starting — \(imageData.count) bytes")

            guard let url = URL(string: "https://api.cloudinary.com/v1_1/\(configuration.cloudName)/image/upload") else {
                throw CloudinaryUploadError.invalidURL
            }

            let boundary = "Boundary-\(UUID().uuidString)"
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            // 1. توليد بيانات الـ Body
            let bodyData = multipartBody(imageData: imageData, boundary: boundary)
            
            // 2. إضافة Content-Length (يساعد السيرفر على عدم الانتظار بلا داعي)
            request.setValue("\(bodyData.count)", forHTTPHeaderField: "Content-Length")
            
            // لاحظ أننا لم نقم بتعيين request.httpBody هنا لأننا سنمرره في دالة upload مباشرة

            let start = Date()
            do {
                // 3. التغيير الأهم: استخدام دالة upload بدلاً من data
                let (data, response) = try await session.upload(for: request, from: bodyData)
                
                print("☁️ Cloudinary responded in \(Date().timeIntervalSince(start))s")

                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CloudinaryUploadError.invalidResponse
                }
                guard (200...299).contains(httpResponse.statusCode) else {
                    let message = (try? JSONDecoder().decode(CloudinaryErrorEnvelope.self, from: data))?.error.message
                    throw CloudinaryUploadError.serverError(statusCode: httpResponse.statusCode, message: message)
                }

                // Decode secure_url, public_id, etc.
                do {
                    return try JSONDecoder().decode(CloudinaryUploadResponse.self, from: data)
                } catch {
                    throw CloudinaryUploadError.decodingFailed
                }
            } catch let urlError as URLError {
                print("☁️ Cloudinary FAILED after \(Date().timeIntervalSince(start))s — \(urlError)")
                throw CloudinaryUploadError.invalidURL // أو يمكنك رمي الخطأ الأصلي
            }
        }

    private func multipartBody(imageData: Data, boundary: String) -> Data {
        var body = Data()
        let crlf = "\r\n"

        body.append("--\(boundary)\(crlf)")
        body.append("Content-Disposition: form-data; name=\"upload_preset\"\(crlf)\(crlf)")
        body.append("\(configuration.uploadPreset)\(crlf)")

        body.append("--\(boundary)\(crlf)")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"upload.jpg\"\(crlf)")
        body.append("Content-Type: image/jpeg\(crlf)\(crlf)")
        body.append(imageData)
        body.append(crlf)

        body.append("--\(boundary)--\(crlf)")
        return body
    }
}

private struct CloudinaryErrorEnvelope: Decodable {
    struct ErrorDetail: Decodable { let message: String }
    let error: ErrorDetail
}

private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}
