//
//  PhoneNumberView.swift
//  Carely
//
//  Created by Mohamed Ayman on 16/07/2026.
//

import SwiftUI

struct PhoneNumberView : View {
    @StateObject var viewModel : PhoneNumberViewModel

        var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                AppHeader(title: "Join us via phone number")
                
                Text("We'll text a code to verify your phone.")
                    .carelyText(style: .bodyRegular, weight: .light)
                    .foregroundStyle(Color.primaryFont)
                
                PhoneNumberField(
                    phoneNumber: $viewModel.phoneNumber,
                    showError: viewModel.showPhoneNumberError,
                    onFocusChanged: viewModel.phoneNumberFieldFocusChanged,
                    onPhoneNumberChanged: viewModel.phoneNumberChanged
                )

                Text("Carrier charges may apply for SMS.")
                    .carelyText(style: .caption)
                    .foregroundStyle(Color.hint)

                SecurityCard()

                HStack{
                    ActionCard(
                        title: "Instant SMS",
                        image: Image(systemName: "ellipsis.message"),
                        backgroundColor: .primaryContainer,
                        foregroundColor: .onBankContainer
                    )

                    ActionCard(
                        title: "Verified Private",
                        image: Image(systemName: "lock.fill"),
                        backgroundColor: .disable,
                        foregroundColor: .hint
                    )
                }

                Spacer()

                loginButton(
                    title: "NEXT",
                    backgroundColor: .brandPrimary,
                    strokeColor: .brandPrimary
                ) {
                    viewModel.nextButtonPressed()
                }
                .disabled(!viewModel.isPhoneNumberValid)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .padding(12)
            .background(Color.backGround)
        }
}

//#Preview {
//    let router = AuthRouter()
//    let viewModel = PhoneNumberViewModel(router: router)
//    PhoneNumberView(viewModel:viewModel)
//}
