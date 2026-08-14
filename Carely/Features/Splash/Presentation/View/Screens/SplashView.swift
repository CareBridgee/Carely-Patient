//
//  SplashView.swift
//  Carely
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel
    @State private var isAnimating: Bool = false
    let onSplashFinished: () -> Void
    
    init(
        viewModel: SplashViewModel,
        onSplashFinished: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSplashFinished = onSplashFinished
    }
    
    var body: some View {
        ZStack {
            Color.brandPrimary.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                    Image.logo
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 180)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .opacity(isAnimating ? 1.0 : 0.0)
                
                Spacer().frame(height: Spacing.s24)
                
                Text(AppConstants.appName)
                    .carelyText(style: .display, weight: .semiBold)
                    .foregroundColor(.onPrimary)
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: Spacing.s8)
                
                Text("Personalized home care with a\nhuman touch.")
                    .carelyText(style: .bodyRegular, weight: .regular)
                    .foregroundColor(.onPrimary.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                Spacer().frame(height: Spacing.s48)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .onPrimary))
                    .scaleEffect(1.2)
                    .frame(width: 40, height: 40)
                
                Spacer().frame(height: Spacing.s16)
                
                Text("INITIALIZING CARE")
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.onPrimary.opacity(0.8))
                    .tracking(2) // Similar to letterSpacing in compose
                
                Spacer()
                
                Text("Trusted by thousands of families worldwide")
                    .carelyText(style: .caption, weight: .regular)
                    .foregroundColor(.onPrimary.opacity(0.7))
                    .padding(.bottom, Spacing.s32)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                isAnimating = true
            }
            viewModel.onSplashFinished = onSplashFinished
            viewModel.initializeApp()
        }
    }
}
