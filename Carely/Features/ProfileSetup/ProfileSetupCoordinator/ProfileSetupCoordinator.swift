import Foundation

// MARK: - ProfileSetupCoordinator

@MainActor
final class ProfileSetupCoordinator: ObservableObject {

    // MARK: - Published State

    @Published private(set) var currentStep: ProfileSetupStep
    @Published private(set) var data: ProfileSetupData
    @Published private(set) var profileId: String?
    @Published private(set) var isLoadingData: Bool = false
    let steps: [ProfileSetupStep]

    func setProfileId(_ id: String) {
        self.profileId = id
    }

    func loadExistingProfileData(networkService: ProfileNetworkServiceProtocol) async {
        guard let pid = profileId else { return }
        isLoadingData = true
        defer { isLoadingData = false }
        do {
            let allProfiles = try await networkService.fetchAllProfiles()
            guard let match = allProfiles.first(where: { $0.id == pid }) else { return }
            
            var bloodTypeStr = match.bloodType ?? ""
            if bloodTypeStr.count > 3 { bloodTypeStr = "" }
            
            let basic = BasicHealthInfo(
                height: match.height,
                weight: match.weight,
                bloodType: bloodTypeStr
            )
            
            let surgeries = match.previousSurgeries ?? ""
            let hospitalizations = match.previousHospitalizations ?? ""
            let history = MedicalHistory(
                previousSurgeries: surgeries,
                previousHospitalizations: hospitalizations
            )
            
            var status: MobilityStatus? = nil
            if let s = match.mobilityStatus {
                status = MobilityStatus.allCases.first { $0.title.lowercased() == s.lowercased() }
            }
            let mobility = Mobility(
                status: status,
                additionalNotes: match.mobilityNotes ?? ""
            )
            
            self.save(basicHealthInfo: basic)
            self.save(medicalHistory: history)
            self.save(mobility: mobility)
        } catch {
            // Keep current data on failure
        }
    }
    
    // MARK: - Init

    init(
        data: ProfileSetupData,
        steps: [ProfileSetupStep] = ProfileSetupStep.allCases,
        startingStep: ProfileSetupStep? = nil
    ) {
        self.data = data
        self.steps = steps
        self.currentStep = startingStep ?? steps.first ?? .basicHealthInfo
    }

    // MARK: - Navigation

    func next() {
        guard let currentIndex = steps.firstIndex(of: currentStep),
              currentIndex + 1 < steps.count else { return }
        currentStep = steps[currentIndex + 1]
    }

    func previous() {
        guard let currentIndex = steps.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        currentStep = steps[currentIndex - 1]
    }

    func go(to step: ProfileSetupStep) {
        guard steps.contains(step) else { return }
        currentStep = step
    }
    
    // MARK: - Save Data
    
    func save(basicHealthInfo: BasicHealthInfo) {
        data.basicHealthInfo = basicHealthInfo
    }
    
    func save(existingConditions: ExistingConditions)   {
        data.existingConditions = existingConditions
    }
    
    func save(allergies: Allergies) {
        data.allergies = allergies
    }
    
    func save(currentMedication: CurrentMedication) {
        data.currentMedication = currentMedication
    }
    
    func save(medicalHistory: MedicalHistory) {
        data.medicalHistory = medicalHistory
    }
    
    func save(mobility: Mobility) {
        data.mobility = mobility
    }
    
    func save(emergencyContact: EmergencyContact) {
        data.emergencyContact = emergencyContact
    }
    
    func save(homeAddress: HomeAddress) {
        data.homeAddress = homeAddress
    }

    // MARK: - Derived State

    var isFirstStep: Bool {
        currentStep == steps.first
    }

    var isLastStep: Bool {
        currentStep == steps.last
    }

    var currentStepIndex: Int {
        (steps.firstIndex(of: currentStep) ?? 0) + 1
    }

    var totalSteps: Int {
        steps.count
    }

    var progress: Double {
        guard let currentIndex = steps.firstIndex(of: currentStep), !steps.isEmpty else { return 0 }
        return Double(currentIndex + 1) / Double(steps.count)
    }
}
