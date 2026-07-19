import SwiftUI

struct Step2View: View {
    @StateObject private var viewModel = Step2ViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Omitting HealthProfileHeaderView as requested ("I don't want the header above")
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s20) {
                    StepProgressHeader(
                        currentStep: 2,
                        totalSteps: 8,
                        stepTitle: "Medical Conditions"
                    )
                    .padding(.top, Spacing.s16)
                    
                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        Text("Any existing conditions?")
                            .carelyText(style: .bodyLarge, weight: .medium )
                        
                            .foregroundColor(.primaryFont)
                        
                        Text("Select all that apply to help us provide more personalized care for your needs.")
                            .carelyText(style: .bodySmall, weight: .light)
                            .foregroundColor(.secondaryFont)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.s20), GridItem(.flexible())], spacing: Spacing.s16) {
                        ForEach(viewModel.availableConditions, id: \.title) { condition in
                            ConditionCardView(
                                title: condition.title,
                                icon: condition.icon,
                                isSelected: viewModel.selectedConditions.contains(condition.title),
                                action: {
                                    viewModel.toggleCondition(condition.title)
                                }
                            )
                        }
                    }
                    
                    OtherDiseasesSectionView(text: $viewModel.otherDiseases)
                        .padding(.top, Spacing.s8)
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.bottom, Spacing.s32)
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

#Preview {
    Step2View()
}
