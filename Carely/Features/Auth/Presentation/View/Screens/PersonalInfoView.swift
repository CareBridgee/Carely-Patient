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
    
    init(viewModel: @autoclosure @escaping () -> PersonalInfoViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    var body: some View {
        VStack(spacing: Spacing.s20) {
            
            AppHeader(title: "Enaya")
            
            PersonalInfoFormCard(viewModel: viewModel)
                .padding(.top, Spacing.s24)
            
            Spacer()
        }
        .padding(.horizontal, Spacing.s16)
        .background(Color.backGround.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}
