//
//  PersonalInfoView.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI

import SwiftUI

struct PersonalInfoView: View {
    @StateObject var viewModel: PersonalInfoViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: Spacing.xl) {
            
            AppHeader(title: "Enaya")
            
            PersonalInfoFormCard(viewModel: viewModel)
                .padding(.top, Spacing.xxl)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.lg)
        .background(Color.backGround.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}
