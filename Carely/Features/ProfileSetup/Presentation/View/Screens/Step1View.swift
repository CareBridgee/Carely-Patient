import SwiftUI

struct Step1View: View {
    @StateObject private var viewModel = Step1ViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s24) {
                    StepProgressHeader(
                        currentStep: 1,
                        totalSteps: 8,
                        stepTitle: "Health Profile"
                    )
                    .padding(.top, Spacing.s16)
                    
                    HealthInfoCardView()
                    
                    HStack(spacing: Spacing.s16) {
                        MeasurementInputCardView(
                            title: "Height",
                            placeholder: "170",
                            unit: "cm",
                            value: $viewModel.height
                        )
                        
                        MeasurementInputCardView(
                            title: "Weight",
                            placeholder: "65",
                            unit: "kg",
                            value: $viewModel.weight
                        )
                    }
                    
                    BloodTypeSelectionCardView(selectedType: $viewModel.bloodType)
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.bottom, Spacing.s24)
            }
            
            HealthProfileBottomActionsView(
                onBackTapped: {
                    // Handle back action
                },
                onContinueTapped: {
                    // Handle continue action
                }
            )
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
    }
}

struct Step1View_Previews: PreviewProvider {
    static var previews: some View {
        Step1View()
    }
}
