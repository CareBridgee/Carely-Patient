import SwiftUI

struct ExistingConditionsView: View {

    let coordinator: ProfileSetupCoordinator
    @StateObject private var viewModel : ExistingConditionsViewModel
    
    init(coordinator: ProfileSetupCoordinator,viewModel: @autoclosure @escaping () -> ExistingConditionsViewModel
    ) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s20) {
                
                headerTitles
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.s20), GridItem(.flexible())], spacing: Spacing.s16) {
                    ForEach(viewModel.availableConditions, id: \.title) { condition in
                        ConditionCardView(
                            title: condition.title,
                            icon: condition.icon,
                            isSelected: viewModel.existingConditions.selectedConditions.contains(condition.title),
                            action: { viewModel.toggleCondition(condition.title) }
                        )
                    }
                }
                
                OtherDiseasesSectionView(text: $viewModel.existingConditions.otherDiseases)
                    .padding(.top, Spacing.s8)
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s32)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: {
                    coordinator.previous()
                    coordinator.save(existingConditions: viewModel.existingConditions)
                    },
                onContinueTapped: {
                    coordinator.save(existingConditions: viewModel.existingConditions)
                    coordinator.next() }
            )
        } .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    
    private var headerTitles: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text("Any existing conditions?")
                .carelyText(style: .bodyLarge, weight: .medium )
                .foregroundColor(.primaryFont)
            
            Text("Select all that apply to help us provide more personalized care for your needs.")
                .carelyText(style: .bodySmall, weight: .light)
                .foregroundColor(.secondaryFont)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
