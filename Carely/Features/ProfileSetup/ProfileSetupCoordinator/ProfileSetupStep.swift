import Foundation

// MARK: - ProfileSetupStep

enum ProfileSetupStep: CaseIterable {
    case basicHealthInfo
    case existingConditions
    case allergies
    case currentMedication
    case medicalHistory
    case mobility
    case emergencyContact
    case homeAddress
}

// MARK: - Sequencing

extension ProfileSetupStep {

    var next: ProfileSetupStep? {
        let allSteps = Self.allCases
        guard
            let currentIndex = allSteps.firstIndex(of: self),
            allSteps.index(after: currentIndex) < allSteps.endIndex
        else {
            return nil
        }
        return allSteps[allSteps.index(after: currentIndex)]
    }

    var previous: ProfileSetupStep? {
        let allSteps = Self.allCases
        guard
            let currentIndex = allSteps.firstIndex(of: self),
            currentIndex > allSteps.startIndex
        else {
            return nil
        }
        return allSteps[allSteps.index(before: currentIndex)]
    }

    var isFirst: Bool {
        self == Self.allCases.first
    }

    var isLast: Bool {
        self == Self.allCases.last
    }
    
    var stepTitle: String {
        switch self {
        case .basicHealthInfo:
            return "Basic Health Info"
        case .existingConditions:
            return "Existing Conditions"
        case .allergies:
            return "Allergies"
        case .currentMedication:
            return "Current Medication"
        case .medicalHistory:
            return "Medical History"
        case .mobility:
            return "Mobility"
        case .emergencyContact:
            return "Emergency Contact"
        case .homeAddress:
            return "Home Address"
        }
    }
}
