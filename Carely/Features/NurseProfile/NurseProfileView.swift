import SwiftUI

struct NurseProfileView: View {
    @StateObject private var viewModel: NurseProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: NurseProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.brandPrimary))
            } else if let profile = viewModel.profile {
                ScrollView {
                    VStack(spacing: Spacing.s24) {
                        // Header
                        NurseProfileHeaderView(profile: profile)
                        
                        // Services
                        NurseProfileServicesView(profile: profile)
                        
                        // Certificates
                        NurseProfileCertificatesView(profile: profile)
                        
                        // Approach
                        NurseProfileApproachView(profile: profile)
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.bottom, Spacing.s32)
                }
            }
        }
        .careConnectNavigationBar(
            title: "CareConnect",
            //trailingIcon: "bell",
            onBackTapped: { presentationMode.wrappedValue.dismiss() }
//            onTrailingIconTapped: {
//                // Bell action
//            }
        )
        .onAppear {
            viewModel.fetchProfile()
        }
    }
}

#Preview {
    NurseProfileView(viewModel: NurseProfileViewModel(nurseId: "nurse_1"))
}
