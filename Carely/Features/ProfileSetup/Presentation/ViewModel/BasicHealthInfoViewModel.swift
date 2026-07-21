//
//  BasicHealthInfoViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class BasicHealthInfoViewModel: ObservableObject {
    @Published var heightText: String
    @Published var weightText: String
    @Published var bloodType: String
    
    init(existingData: BasicHealthInfo) {
            self.heightText = Self.format(value: existingData.height)
            self.weightText = Self.format(value: existingData.weight)
            self.bloodType = existingData.bloodType
        }
        
        private static func format(value: Double?) -> String {
            guard let val = value else { return "" }
            return val.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", val) : String(val)
        }
    
    var basicHealthInfo: BasicHealthInfo {
        BasicHealthInfo(
            height: Double(heightText),
            weight: Double(weightText),
            bloodType: bloodType
        )
    }

    var isFormValid: Bool {
        let isHeightValid = heightText.isEmpty || Double(heightText) != nil
        let isWeightValid = weightText.isEmpty || Double(weightText) != nil
        
        return isHeightValid && isWeightValid
    }
    
    var heightError: String? {
        if !heightText.isEmpty && Double(heightText) == nil {
            return "Invalid height format"
        }
        return nil
    }
    
    var weightError: String? {
        if !weightText.isEmpty && Double(weightText) == nil {
            return "Invalid weight format"
        }
        return nil
    }
}
