import SwiftUI

struct CareConnectNavigationBarModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    var showBackButton: Bool = true
    var trailingIcon: String? = nil
    var onBackTapped: (() -> Void)? = nil
    var onTrailingIconTapped: (() -> Void)? = nil
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if showBackButton {
                        Button(action: {
                            if let onBackTapped = onBackTapped {
                                onBackTapped()
                            } else {
                                dismiss()
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(Color.brandPrimary)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .carelyText(style: .heading3, weight: .medium)
                        .foregroundColor(Color.brandPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if let icon = trailingIcon {
                        Button(action: {
                            onTrailingIconTapped?()
                        }) {
                            Circle()
                                .fill(Color.brandPrimary.opacity(0.1))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Image(systemName: icon)
                                        .foregroundColor(Color.brandPrimary)
                                        .font(.system(size: 12))
                                )
                        }
                    }
                }
            }
    }
}

extension View {
    func careConnectNavigationBar(
        title: String = AppConstants.appName,
        showBackButton: Bool = true,
        trailingIcon: String? = nil,
        onBackTapped: (() -> Void)? = nil,
        onTrailingIconTapped: (() -> Void)? = nil
    ) -> some View {
        self.modifier(CareConnectNavigationBarModifier(
            title: title,
            showBackButton: showBackButton,
            trailingIcon: trailingIcon,
            onBackTapped: onBackTapped,
            onTrailingIconTapped: onTrailingIconTapped
        ))
    }
}
