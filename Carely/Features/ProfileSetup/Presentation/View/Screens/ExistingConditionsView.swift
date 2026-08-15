import SwiftUI

struct ExistingConditionsView: View {

    let coordinator: ProfileSetupCoordinator
    @StateObject private var viewModel: ExistingConditionsViewModel
    
    init(coordinator: ProfileSetupCoordinator, viewModel: @autoclosure @escaping () -> ExistingConditionsViewModel) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s20) {
                ProfileSetupHeaderView(
                    title: "Any existing conditions?",
                    subtitle: "Select all that apply to help us provide more personalized care for your needs."
                )

                if viewModel.isLoading && viewModel.availableConditions.isEmpty {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.s20), GridItem(.flexible())], spacing: Spacing.s16) {
                        ForEach(0..<6, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: Spacing.s8) {
                                EtmaenSkeletonCircle(size: 24)
                                EtmaenSkeletonRect(width: 80, height: 14, radius: Radius.r8)
                            }
                            .padding(Spacing.s16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.surface)
                            .cornerRadius(Radius.r12)
                            .overlay(
                                RoundedRectangle.carely(Radius.r12)
                                    .stroke(Color.brandPrimary.opacity(0.15), lineWidth: 0.5)
                            )
                        }
                    }
                } else if viewModel.availableConditions.isEmpty {
                    Text("No medical conditions found.")
                        .carelyText(style: .bodyRegular, weight: .medium)
                        .foregroundColor(.secondaryFont)
                        .padding(.top, Spacing.s32)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.s20), GridItem(.flexible())], spacing: Spacing.s16) {
                        ForEach(viewModel.availableConditions) { condition in
                            ConditionCardView(
                                title: condition.name,
                                icon: conditionIcon(for: condition.name),
                                isSelected: viewModel.isSelected(condition.id),
                                action: { viewModel.toggleCondition(condition.id) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.s20)
            .padding(.bottom, Spacing.s32)
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            viewModel.onAppear()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred.")
        }
        .safeAreaInset(edge: .bottom) {
            HealthProfileBottomActionsView(
                onBackTapped: { viewModel.backTapped() },
                onContinueTapped: { viewModel.continueTapped() }
            )
        }
    }

    private func conditionIcon(for name: String) -> String {
        let lower = name.lowercased()
        if lower.contains("diabet") { return "diabetes-icon" }
        if lower.contains("hypertens") || lower.contains("pressure") { return "hypertension-icon" }
        if lower.contains("heart") || lower.contains("cardio") { return "heart-disease-icon" }
        if lower.contains("asthma") { return "asthma-icon" }
        if lower.contains("copd") { return "COPD-icon" }
        if lower.contains("epilep") || lower.contains("seizure") { return "epilepsy-icon" }
        if lower.contains("liver") || lower.contains("hepat") { return "liver-disease-icon" }
        return "heart-disease-icon"
    }
}
