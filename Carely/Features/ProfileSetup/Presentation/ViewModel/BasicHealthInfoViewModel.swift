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

    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    private let getProfileIdUseCase: ProfileIdProviding
    private let updateBasicInfoUseCase: UpdateBasicHealthInfoUseCase
    private let onContinue: (BasicHealthInfo) -> Void
    private let onBack: (BasicHealthInfo) -> Void

    private let minHeight: Double = 50.0
    private let maxHeight: Double = 300.0
    private let minWeight: Double = 2.0
    private let maxWeight: Double = 400.0
    private let initialData: BasicHealthInfo

    init(
        existingData: BasicHealthInfo,
        getProfileIdUseCase: ProfileIdProviding,
        updateBasicInfoUseCase: UpdateBasicHealthInfoUseCase,
        onContinue: @escaping (BasicHealthInfo) -> Void,
        onBack: @escaping (BasicHealthInfo) -> Void
    ) {
        self.heightText = Self.format(value: existingData.height)
        self.weightText = Self.format(value: existingData.weight)
        self.bloodType = existingData.bloodType
        self.getProfileIdUseCase = getProfileIdUseCase
        self.updateBasicInfoUseCase = updateBasicInfoUseCase
        self.onContinue = onContinue
        self.onBack = onBack
        self.initialData = existingData
    }

    private static func format(value: Double?) -> String {
        guard let val = value else { return "" }
        return val.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", val) : String(val)
    }

    var basicHealthInfo: BasicHealthInfo {
        BasicHealthInfo(height: Double(heightText), weight: Double(weightText), bloodType: bloodType)
    }

    var heightError: String? {
        guard !heightText.isEmpty else { return nil }
        guard let height = Double(heightText) else { return "Invalid height" }
        guard height >= minHeight && height <= maxHeight else {
            return "Height: \(Int(minHeight))-\(Int(maxHeight)) cm"
        }
        return nil
    }

    var weightError: String? {
        guard !weightText.isEmpty else { return nil }
        guard let weight = Double(weightText) else { return "Invalid weight" }
        guard weight >= minWeight && weight <= maxWeight else {
            return "Weight: \(Int(minWeight))-\(Int(maxWeight)) kg"
        }
        return nil
    }

    var isFormValid: Bool { heightError == nil && weightError == nil }

    func backTapped() {
        onBack(basicHealthInfo)
    }

    func continueTapped() {
            let hVal = heightText.trimmingCharacters(in: .whitespaces)
            let wVal = weightText.trimmingCharacters(in: .whitespaces)
            
            let isCompletelyEmpty = hVal.isEmpty && wVal.isEmpty && bloodType.isEmpty
            let isFullyFilled = !hVal.isEmpty && !wVal.isEmpty && !bloodType.isEmpty
            
            if isCompletelyEmpty {
                onContinue(basicHealthInfo)
                return
            }
            
            guard isFullyFilled else {
                self.errorMessage = "Please fill in all fields (Height, Weight, and Blood Type) or clear all data to skip this step."
                self.showError = true
                return
            }

            guard isFormValid else { return }
            
            if self.basicHealthInfo == self.initialData {
                onContinue(self.basicHealthInfo)
                return
            }

            guard NetworkMonitor.shared.isConnected else {
                self.errorMessage = "No internet connection. Please check your network."
                self.showError = true
                return
            }

            isLoading = true
            errorMessage = nil

            Task {
                do {
                    let profileId = try await getProfileIdUseCase.execute()
                    try await updateBasicInfoUseCase.execute(profileId: profileId, info: basicHealthInfo)
                    
                    await MainActor.run {
                        self.isLoading = false
                        self.onContinue(self.basicHealthInfo)
                    }
                } catch {
                    await MainActor.run {
                        self.isLoading = false
                        self.errorMessage = error.localizedDescription
                        self.showError = true
                    }
                }
            }
        }
}
