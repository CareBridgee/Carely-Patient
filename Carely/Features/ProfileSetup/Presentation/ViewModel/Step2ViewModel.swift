import Foundation

class Step2ViewModel: ObservableObject {
    @Published var selectedConditions: Set<String> = []
    @Published var otherDiseases: String = ""
    
    let availableConditions: [(title: String, icon: String)] = [
        ("Diabetes", "diabetes-icon"),
        ("Hypertension", "hypertension-icon"),
        ("Heart Disease", "heart-disease-icon"),
        ("Asthma", "asthma-icon"),
        ("COPD", "COPD-icon"),
        ("Epilepsy", "epilepsy-icon"),
        ("Liver Disease", "liver-disease-icon")
    ]
    
    func toggleCondition(_ condition: String) {
        if selectedConditions.contains(condition) {
            selectedConditions.remove(condition)
        } else {
            selectedConditions.insert(condition)
        }
    }
}
