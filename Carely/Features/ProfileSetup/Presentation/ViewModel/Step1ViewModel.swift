import Foundation

final class Step1ViewModel: ObservableObject {
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bloodType: String = ""
}
