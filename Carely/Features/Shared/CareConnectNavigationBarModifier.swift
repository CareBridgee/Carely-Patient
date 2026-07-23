import SwiftUI

struct CareConnectNavigationBarModifier: ViewModifier {
    let title: String
    let trailingIcon: String?
    let onBackTapped: () -> Void
    let onTrailingIconTapped: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBackTapped) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(Color.brandPrimary)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .carelyText(style: .heading3, weight: .bold)
                        .foregroundColor(Color.brandPrimary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let icon = trailingIcon, let action = onTrailingIconTapped {
                        Button(action: action) {
                            Image(systemName: icon)
                                .foregroundColor(Color.brandPrimary)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }
            }
    }
}

extension View {
    func careConnectNavigationBar(
        title: String = "CareConnect",
        trailingIcon: String? = nil,
        onBackTapped: @escaping () -> Void,
        onTrailingIconTapped: (() -> Void)? = nil
    ) -> some View {
        self.modifier(CareConnectNavigationBarModifier(
            title: title,
            trailingIcon: trailingIcon,
            onBackTapped: onBackTapped,
            onTrailingIconTapped: onTrailingIconTapped
        ))
    }
}
