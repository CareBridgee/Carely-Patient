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
        VStack(spacing: 24) {
            
            AppHeader(title: "Enaya")
            
            PersonalInfoFormCard(viewModel: viewModel)
                .padding(.top, 36)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.backGround.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}
