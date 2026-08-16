//
//  MeResponseDTO.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/08/2026.
//


import Foundation
import Alamofire // Assuming you use Alamofire based on previous logs

// MARK: - DTOs
struct MeResponseDTO: Decodable {
    let id: String
    let firstName: String?
    let lastName: String?
}



// MARK: - Endpoint Additions
